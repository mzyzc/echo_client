import 'package:flutter/material.dart';
import 'package:echo_client/server.dart';
import 'package:echo_client/message.dart';
import 'package:echo_client/user.dart';
import 'package:echo_client/conversation.dart';

class MessagesPage extends StatelessWidget {
  final Conversation conversation;
  MessagesPage(this.conversation);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(conversation.name),
        ),
        body: Column(children: <Widget>[
          MessagesList(conversation),
          Divider(),
          Align(
              alignment: Alignment.bottomCenter,
              child: MessageBar(conversation)),
        ]));
  }
}

class MessagesList extends StatefulWidget {
  final Conversation conversation;

  const MessagesList(this.conversation);

  @override
  _MessagesListState createState() => _MessagesListState(conversation);
}

class _MessagesListState extends State<MessagesList> {
  final Conversation conversation;
  List<Message> _messagesList = [];
  List<User> _usersList = [];

  _MessagesListState(this.conversation);

  Future<void> refresh() async {
    final server = new Server();
    _messagesList = (await server.getMessages(conversation.id)).messages;
    _usersList = (await server.getUsers(conversation.id)).users;
  }

  @override
  void initState() {
    super.initState();
    setState(() => refresh);
  }

  @override
  Widget build(BuildContext context) {
    const altDirection = [TextDirection.rtl, TextDirection.ltr];

    return Expanded(
        child: Scrollbar(
            child: ListView.builder(
                reverse: true,
                itemCount: _messagesList.length,
                itemBuilder: (context, index) {
                  return Directionality(
                      textDirection: altDirection[index % 2],
                      child: MessageTile(_messagesList[index]));
                })));
  }
}

class MessageTile extends StatelessWidget {
  final Message data;

  const MessageTile(this.data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(data.messageData),
      subtitle: Text(data.timeSent),
    );
  }
}

class MessageBar extends StatelessWidget {
  String messageText;
  final Conversation conversation;

  MessageBar(this.conversation);

  @override
  Widget build(BuildContext build) {
    return Row(children: <Widget>[
      Expanded(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: TextField(
            onChanged: (text) => messageText = text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write a message...',
            )),
      )),
      Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          child: Icon(Icons.send),
          onPressed: () => newMessage(messageText, conversation.id),
        ),
      )
    ]);
  }
}
