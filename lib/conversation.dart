class Conversation {
  int _id;
  String _name;

  Conversation.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  int get id {
    return _id;
  }

  String get name {
    return _name;
  }
}
