import 'dart:convert';
import 'package:echo_client/response.dart';

class DummyServer {
  static Response get messages {
    final messageJson = json.encode({
      "status": 1,
      "messages": [
        {
          "id": 1,
          "data":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 2,
          "data":
              "Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 3,
          "data":
              "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 4,
          "data":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 5,
          "data":
              "Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 6,
          "data":
              "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 7,
          "data":
              "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 8,
          "data":
              "Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.",
          "mediaType": "text/plain",
          "timestamp": "2014-02-15T08:57:47.812",
          "signature": "cHJldGVuZCB0aGlzIGlzIGEgdmFsaWQgc2lnbmF0dXJl",
        },
        {
          "id": 9,
          "data":
              "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus.",
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
          "name": "Lucas Metallo",
        },
        {
          "id": 2,
          "name": "Cornelia Niss",
        },
        {
          "id": 3,
          "name": "Melanie Stockman",
        },
        {
          "id": 4,
          "name": "Tabetha Kottsick",
        },
        {
          "id": 5,
          "name": "Lashay Meggison",
        },
        {
          "id": 6,
          "name": "Mack Corporon",
        },
        {
          "id": 7,
          "name": "Jefferson Czachorowski",
        },
        {
          "id": 8,
          "name": "Louie Simms",
        },
        {
          "id": 9,
          "name": "Tinisha Bartow",
        },
        {
          "id": 10,
          "name": "Nidia Mcmilliam",
        },
        {
          "id": 11,
          "name": "Birgit Sando",
        },
        {
          "id": 12,
          "name": "Raeann Diserens",
        },
        {
          "id": 13,
          "name": "Talitha Stsauveur",
        },
        {
          "id": 14,
          "name": "Wilbert Salman",
        },
        {
          "id": 15,
          "name": "Tyler Seher",
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
          "email": "wilbert@example.com",
          "displayName": "Wilbert Salman",
          "publicKey": "a2V5",
        },
        {
          "id": 2,
          "email": "tyler@example.com",
          "displayName": "Tyler Seher",
          "publicKey": "a2V5",
        },
        {
          "id": 3,
          "email": "simms@example.com",
          "displayName": "Louie Simms",
          "publicKey": "a2V5",
        },
      ]
    });

    return Response(utf8.encode(userJson));
  }
}
