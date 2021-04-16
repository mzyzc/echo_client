import 'dart:convert';
import 'package:echo_client/response.dart';

class DummyServer {
  static Response get messages {
    final messageJson = json.encode({
      "status": 1,
      "messages": [
        {
          "id": 1,
          "data": "Hello",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 2,
          "data": "Hello",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 3,
          "data": "Hello",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
      ]
    });

    return Response(utf8.encode(messageJson));
  }

  static Response get conversations {
    final conversationJson = json.encode({
      "status": 1,
      "conversations": [
        {
          "id": 1,
          "name": "Genesis",
        },
        {
          "id": 2,
          "name": "Second Hand",
        },
        {
          "id": 3,
          "name": "Lucky Lucky",
        },
      ]
    });

    return Response(utf8.encode(conversationJson));
  }

  static Response get users {
    final userJson = json.encode({
      "status": 1,
      "users": [
        {
          "id": 1,
          "email": "@example.com",
          "displayName": "Bobby Boss",
          "publicKey": "a2V5",
        },
        {
          "id": 2,
          "email": "charles@example.com",
          "displayName": "Charlie Chimney",
          "publicKey": "a2V5",
        },
        {
          "id": 3,
          "email": "dobby@example.com",
          "displayName": "dobby a",
          "publicKey": "a2V5",
        },
      ]
    });

    return Response(utf8.encode(userJson));
  }
}
