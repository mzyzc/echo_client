import 'dart:convert';

class Conversation {
  int _id;
  String _name;

  Conversation.fromJson(String json) {
    final data = jsonDecode(json);

    this._id = data['id'];
    this._name = data['name'];
  }
}
