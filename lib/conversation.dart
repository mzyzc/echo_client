import 'dart:convert';
import 'package:echo_client/user.dart';
import 'package:echo_client/server.dart';

class Conversation {
  int _id;
  String _name;
  List<User> _participants;

  Conversation.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

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

    print(request);

    final server = new Server();
    final response = server.send(request);
  }

  int get id {
    return _id;
  }

  String get name {
    return _name;
  }
}
