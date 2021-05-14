import 'dart:convert';
import 'package:echo_client/user.dart';
import 'package:echo_client/server.dart';

// Represents a conversation in Echo
class Conversation {
  int _id;
  String _name;
  List<User> _participants;

  // Creates a conversation object from JSON
  Conversation.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  // Creates a new conversation
  Conversation.create(this._name, this._participants) {
    final request = jsonEncode({
      "function": "CREATE CONVERSATIONS",
      "conversations": [
        {
          "name": _name,
        }
      ],
      "users": List<Map<String, dynamic>>.from(
          _participants.map((user) => user.toJson())),
    });

    final server = new Server();
    server.send(request);
  }

  int get id {
    return _id;
  }

  String get name {
    return _name;
  }
}
