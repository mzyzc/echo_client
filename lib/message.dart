import 'dart:convert';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class Message {
  List<int> data;
  String mediaType;
  Signature _signature;
  DateTime _timestamp;

  Future<void> initialize(List<int> data, String mediaType) async {
    this.data = data;
    this.mediaType = mediaType;
    this._timestamp = new DateTime.now().toUtc();
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
    this._signature = Signature(digest, publicKey: signKeys.publicKey);
  }

  Future<bool> verifySignature(KeyPair signKeys) async {
    final digest = (await ed25519.sign(data, signKeys)).bytes;
    return await ed25519.verify(digest, _signature);
  }

  Future<void> send(SecretKey sessionKey) async {
    final enData = await _convert(data, sessionKey);
    final enMediaType = await _convert(utf8.encode(mediaType), sessionKey);
    final enTimestamp = await _convert(utf8.encode(_timestamp.toIso8601String()), sessionKey);
    final enSignature = _signature.bytes;

    final messageData = jsonEncode('''
      "message" [
        {
          "data": "$enData",
          "mediaType": "$enMediaType",
          "timestamp": "$enTimestamp",
          "signature": "$enSignature",
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
  final messageData = utf8.encode("This is a message"); // for testing purposes only
  await message.initialize(messageData, "text/plain");
  await message.sign(keys.signingPair);
  message.send(tempSessionKey);
}
