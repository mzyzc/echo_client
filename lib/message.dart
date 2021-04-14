import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class Message {
  List<int> _data;
  String _mediaType;
  Signature _signature;
  DateTime _timestamp;

  Message.fromJson(Map<dynamic, dynamic> json) {
    _data = json['data'];
    _mediaType = json['mediaType'];
    _signature = json['signature'];
    _timestamp = json['timestamp'];
  }

  Message.compose(List<int> data, String mediaType) {
    this._data = data;
    this._mediaType = mediaType;
    this._timestamp = new DateTime.now().toUtc();
  }

  //static Future<List<Message>> fetch(int conversationId) async {
  static Future<void> fetch(int conversationId) async {
    final request = jsonEncode({
      "function": "READ MESSAGES",
      "conversations": [
        {
          "id": conversationId,
        }
      ]
    });

    final server = new Server();
    server.write(request);
    final data = server.read();
  }

  Future<List<int>> _convert(List<int> data, SecretKey sessionKey) async {
    final cipher = AesCtr.with256bits(macAlgorithm: Poly1305());
    final nonce = cipher.newNonce();

    return (await cipher.encrypt(
      data,
      secretKey: sessionKey,
      nonce: nonce,
    ))
        .cipherText;
  }

  Future<void> sign(KeyPair signKeys) async {
    final digest = (await Ed25519().sign(_data, keyPair: signKeys)).bytes;
    _signature =
        Signature(digest, publicKey: await signKeys.extractPublicKey());
  }

  Future<bool> verifySignature(KeyPair signKeys) async {
    final digest = (await Ed25519().sign(_data, keyPair: signKeys)).bytes;
    return await Ed25519().verify(digest, signature: _signature);
  }

  Future<void> send(SecretKey sessionKey) async {
    final enData = await _convert(_data, sessionKey);
    final enMediaType = await _convert(utf8.encode(_mediaType), sessionKey);
    final enTimestamp =
        await _convert(utf8.encode(_timestamp.toIso8601String()), sessionKey);
    final enSignature = _signature.bytes;

    final request = jsonEncode({
      "function": "CREATE MESSAGES",
      "messages": [
        {
          "data": base64.encode(enData),
          "mediaType": base64.encode(enMediaType),
          "timestamp": base64.encode(enTimestamp),
          "signature": base64.encode(enSignature),
          "conversation": 1,
        }
      ]
    });

    final server = new Server();
    server.write(request);
  }
}

Future<void> newMessage(String messageText) async {
  final keys = new Keyring();
  await keys.import();
  final tempSessionKey = await keys.createSessionKey(
      await keys.exchangePair.extractPublicKey()); // for testing purposes only

  final message = Message.compose(
      utf8.encode(messageText), 'text/plain'); // for testing purposes only
  await message.sign(keys.signaturePair);
  await message.send(tempSessionKey);
}
