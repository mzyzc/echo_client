import 'dart:convert';
import 'dart:io';
import 'package:cryptography_flutter/cryptography.dart';

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
    const cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));
    final nonce = cipher.newNonce();
    
    return await cipher.encrypt(
      data,
      secretKey: sessionKey,
      nonce: nonce,
    );
  }
  Future<void> sign(KeyPair signKeys) async {
    final digest = (await ed25519.sign(data, signKeys)).toString();
    this.signature = Signature(utf8.encode(digest), publicKey: signKeys.publicKey);
  }
  Future<bool> _verifySignature(KeyPair signKeys) async {
    final digest = (await ed25519.sign(data, signKeys)).bytes;
    return await ed25519.verify(digest, signature);
  }
  void send() {
    var messageData = '''
      "message" [
        {
          "data": "${data}",
          "mediaType": "${mediaType}",
          "timestamp": "${_timestamp}",
          "signature": "${signature.bytes}",
        }
      ]
    ''';
    var messageObject = jsonEncode(messageData);

    print(messageObject);
    /*
    Socket.connect(InternetAddress.lookup('czyz.xyz'), 63100).then((socket) {
      socket.write(messageObject);
    });
     */
  }
}