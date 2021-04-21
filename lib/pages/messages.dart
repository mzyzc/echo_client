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
    final messages = (await server.getMessages(conversation.id)).messages;
    final users = (await server.getUsers(conversation.id)).users;
    setState(() {
      _messagesList = messages;
      _usersList = users;
    });
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    const altDirection = [TextDirection.rtl, TextDirection.ltr];

    return Expanded(
      child: RefreshIndicator(
        child: Scrollbar(
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                reverse: true,
                itemCount: _messagesList.length,
                itemBuilder: (context, index) {
                  return Directionality(
                      textDirection: altDirection[index % 2],
                      child: MessageTile(_messagesList[index]));
                })),
        onRefresh: refresh,
      ),
    );
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
