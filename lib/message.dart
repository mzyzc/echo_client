import 'dart:io';
import 'dart:convert';
import 'package:cryptography_flutter/cryptography.dart';

class Message {
  String text;
  String mediaType;
  Signature signature;
  DateTime _timestamp;

  void initialize(String text, String mediaType, SecretKey sessionKey, KeyPair signKeys) async {
    this.text = await _convert(text, sessionKey);
    this.mediaType = mediaType;
    this._timestamp = new DateTime.now();
    this.signature = await _sign(text, signKeys);
  }
  Future<String> _convert(String text, var sessionKey) async {
    const cipher = CipherWithAppendedMac(aesCtr, Hmac(sha256));
    final nonce = cipher.newNonce();
    
    return cipher.encrypt(
      utf8.encode(text),
      secretKey: sessionKey,
      nonce: nonce,
    ).toString();
  }
  Future<Signature> _sign(String text, KeyPair signKeys) async {
    final digest = await ed25519.sign(utf8.encode(text), signKeys).toString();
    return Signature(utf8.encode(digest));
  }
  Future<bool> _verifySignature(String text, Signature signature, KeyPair signKeys) async {
    final digest = await _sign(text, signKeys);
    final verified = await ed25519.verify(digest.bytes, signature);
    return verified;
  }
  void send() {
    var messageData = '''
      "message" [
        {
          "text": "${this.text}",
          "mediaType": "${this.mediaType}",
          "timestamp": "${this._timestamp}",
          "signature": "${this.signature}",
        }
      ]
    ''';
    var messageObject = jsonEncode(messageData);

    print(messageObject);
    Socket.connect(InternetAddress.lookup('czyz.xyz'), 63100).then((socket) {
      socket.write(messageObject);
    });
  }
}

class Keyring {
  var exchangePair;
  var signingPair;

  Keyring() {
    _createExchangePair();
    print('Exchange key pair generated!');
    _createSigningPair();
    print('Signing key pair generated!');
  }
  Future<KeyPair> _createExchangePair() async {
    final exchangeKeyPair = await x25519.newKeyPair();
    return exchangeKeyPair;
  }
  Future<KeyPair> _createSigningPair() async {
    final signingKeyPair = await ed25519.newKeyPair();
    return signingKeyPair;
  }
  Future<SecretKey> createSessionKey(remotePubKey) async {
    var sessionKey = await x25519.sharedSecret(
      localPrivateKey: exchangePair.privateKey,
      remotePublicKey: remotePubKey,
    );
    return sessionKey;
  }
}

Future<void> initNewUser() async {
  var keys = new Keyring();
  var message = new Message();
  message.initialize("This is a message", "text/plain", keys.exchangePair.PublicKey, keys.signingPair.privateKey);
  print(message.text);
  message.send();
}