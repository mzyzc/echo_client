import 'dart:convert';
import 'package:echo_client/message.dart';
import 'package:echo_client/user.dart';
import 'package:echo_client/conversation.dart';

class Response {
  int status;
  List<Conversation> conversations;
  List<Message> messages;
  List<User> users;

  // Create a response object from JSON
  Response(List<int> data) {
    final dataString = utf8.decode(data);
    final decoded = jsonDecode(dataString);

    if (decoded.containsKey("status")) {
      status = decoded["status"];
    }
    if (decoded["conversations"] != null) {
      conversations = new List<Conversation>.from(
          decoded["conversations"].map((data) => Conversation.fromJson(data)));
    }
    if (decoded["messages"] != null) {
      messages = new List<Message>.from(
          decoded["messages"].map((data) => Message.fromJson(data)));
    }
    if (decoded["users"] != null) {
      users = new List<User>.from(
          decoded["users"].map((data) => User.fromJson(data)));
    }
  }

  // Check if a request has an acceptable status code
  bool isValid() {
    return (status == 1);
  }
}
