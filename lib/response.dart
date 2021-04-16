import 'dart:convert';
import 'package:echo_client/message.dart';
import 'package:echo_client/user.dart';
import 'package:echo_client/conversation.dart';

class Response {
  int status;
  List<Conversation> conversations;
  List<Message> messages;
  List<User> users;

  Response(List<int> data) {
    final dataString = String.fromCharCodes(data);
    final decoded = jsonDecode(dataString);

    if (decoded.containsKey("status")) {
      status = decoded["status"];
    }
    if (decoded.containsKey("conversations")) {
      conversations = new List<Conversation>.from(
          decoded["conversations"].map((data) => Conversation.fromJson(data)));
    }
    if (decoded.containsKey("messages")) {
      messages = new List<Message>.from(
          decoded["messages"].map((data) => Message.fromJson(data)));
    }
    if (decoded.containsKey("users")) {
      users = new List<User>.from(
          decoded["users"].map((data) => User.fromJson(data)));
    }
  }
}
