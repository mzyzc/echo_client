import 'dart:convert';
import 'dart:io';
import 'package:cryptography_flutter/cryptography.dart';

class Message {
  List<int> data;
  String mediaType;
  Signature signature;
  DateTime _timestamp;

  Future<void> initialize(List<int> data, String mediaType, SecretKey sessionKey, KeyPair signKeys) async {
    this.data = data;
    this.data = await _convert(sessionKey);
    print("text set");
    this.mediaType = mediaType;
    print("mediatype set");
    this._timestamp = new DateTime.now();
    print("timestamp set");
    this.signature = await _sign(signKeys);
    print("signature set");
  }
  Future<List<int>> _convert(SecretKey sessionKey) async {
    const cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));
    final nonce = cipher.newNonce();
    
    return cipher.encrypt(
      data,
      secretKey: sessionKey,
      nonce: nonce,
    );
  }
  Future<Signature> _sign(KeyPair signKeys) async {
    final digest = await ed25519.sign(data, signKeys).toString();
    return Signature(utf8.encode(digest), publicKey: signKeys.publicKey);
  }
  Future<bool> _verifySignature(Signature signature, KeyPair signKeys) async {
    final digest = await _sign(signKeys);
    final isVerified = await ed25519.verify(digest.bytes, signature);
    return isVerified;
  }
  void send() {
    var messageData = '''
      "message" [
        {
          "data": "${utf8.decode(data)}",
          "mediaType": "${mediaType}",
          "timestamp": "${_timestamp}",
          "signature": "${signature}",
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