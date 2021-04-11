import 'dart:convert';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class Message {
  List<int> _data;
  String _mediaType;
  Signature _signature;
  DateTime _timestamp;

  Message.fromJson(String json) {
    final data = jsonDecode(json);

    this._data = data['data'];
    this._mediaType = data['mediaType'];
    this._signature = data['signature'];
    this._timestamp = data['timestamp'];
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
    final response = server.write(request);
    final data = server.listen();
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
    final digest = (await ed25519.sign(_data, signKeys)).bytes;
    _signature = Signature(digest, publicKey: signKeys.publicKey);
  }

  Future<bool> verifySignature(KeyPair signKeys) async {
    final digest = (await ed25519.sign(_data, signKeys)).bytes;
    return await ed25519.verify(digest, _signature);
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
      keys.exchangePair.publicKey); // for testing purposes only

  final message = Message.compose(
      utf8.encode(messageText), 'text/plain'); // for testing purposes only
  await message.sign(keys.signingPair);
  await message.send(tempSessionKey);
}
