import 'dart:convert';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class Message {
  List<int> data;
  String mediaType;
  Signature signature;
  DateTime _timestamp;

  Future<void> initialize(List<int> data, String mediaType, SecretKey sessionKey, KeyPair signKeys) async {
    this.data = await _convert(data, sessionKey);
    this.mediaType = mediaType;
    this._timestamp = new DateTime.now();
  }

  Future<List<int>> _convert(List<int> data, SecretKey sessionKey) async {
    final cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));
    final nonce = cipher.newNonce();
    
    return await cipher.encrypt(
      data,
      secretKey: sessionKey,
      nonce: nonce,
    );
  }

  Future<void> sign(KeyPair signKeys) async {
    final digest = (await ed25519.sign(data, signKeys)).bytes;
    this.signature = Signature(digest, publicKey: signKeys.publicKey);
  }

  Future<bool> verifySignature(KeyPair signKeys) async {
    final digest = (await ed25519.sign(data, signKeys)).bytes;
    return await ed25519.verify(digest, signature);
  }

  void send() {
    final messageData = jsonEncode('''
      "message" [
        {
          "data": "$data",
          "mediaType": "$mediaType",
          "timestamp": "$_timestamp",
          "signature": "${signature.bytes}",
        }
      ]
    ''');
    print(messageData);
    Server.socket.write(messageData);
  }
}

Future<void> newMessage() async {
  final keys = new Keyring();
  await keys.import();
  final tempSessionKey = await keys.createSessionKey(keys.exchangePair.publicKey); // for testing purposes only

  final message = new Message();
  await message.initialize(utf8.encode("This is a message"), "text/plain", tempSessionKey, keys.signingPair);
  await message.sign(keys.signingPair);
  message.send();
}
