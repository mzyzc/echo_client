import 'dart:convert';

class Conversation {
  int _id;
  String _name;

  Conversation.fromJson(Map<dynamic, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }
}
