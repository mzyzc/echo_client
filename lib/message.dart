import 'dart:io';
import 'dart:convert';
import 'package:cryptography_flutter/cryptography.dart';

class Message {
  var text;
  var mediaType;
  var timestamp;
  var senderID;
  var signature;

  void compose(String message, String mediaType) {
    // TODO
  }
  void encrypt(var sessionKey) {
    // TODO
  }
  void decrypt(var sessionKey) {
    // TODO
  }
  Future<String> sign(KeyPair signKey) async {
    final digest = await ed25519.sign(this.text, signKey).toString();
    return digest;
  }
  Future<bool> verifySignature(var sigPubKey) async {
    final digest = await sign(sigPubKey);
    final verified = await ed25519.verify(utf8.encode(digest), signature);
    return verified;
  }
  void send(var data) {
    this.timestamp = new DateTime.now();
    // TODO

    var messageData = '''
      "message" [
        {
          "text": "${this.text}",
          "mediaType": "${this.mediaType}",
          "timestamp": "${this.timestamp}",
          "senderID": "${this.senderID}",
          "signature": "${this.signature}",
        }
      ]
    ''';
    var messageObject = jsonEncode(messageData);
    // TODO
  }
}

class Keychain {
  var exchangePair;
  var signingPair;

  Keychain() {
    createExchangePair();
    createSigningPair();
  }
  void createExchangePair() async {
    final exchangeKeyPair = await x25519.newKeyPair();
    this.exchangePair = exchangeKeyPair;
  }
  void createSigningPair() async {
    final signingKeyPair = await ed25519.newKeyPair();
    this.signingPair = signingKeyPair;
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
  var keys =  new Keychain();
  // TODO
}