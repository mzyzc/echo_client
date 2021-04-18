import 'package:flutter/material.dart';
import 'package:echo_client/server.dart';
import 'package:echo_client/message.dart';
import 'package:echo_client/conversation.dart';

class MessagesPage extends StatelessWidget {
  final Conversation conversation;
  MessagesPage(this.conversation);

  @override
  Widget build(BuildContext context) {
    const altDirection = [TextDirection.rtl, TextDirection.ltr];

    final server = new Server();
    final messagesList = server.messagesTemp(conversation.id).messages;
    final usersList = server.usersTemp(conversation.id).users;

    return Scaffold(
        appBar: AppBar(
          title: Text(conversation.name),
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        return Directionality(
                            textDirection: altDirection[index % 2],
                            child: MessageTile(messagesList[index]));
                      }))),
          Divider(),
          Align(
              alignment: Alignment.bottomCenter,
              child: MessageBar(conversation)),
        ]));
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
