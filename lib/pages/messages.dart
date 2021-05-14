import 'package:flutter/material.dart';
import 'package:echo_client/server.dart';
import 'package:echo_client/message.dart';
import 'package:echo_client/user.dart';
import 'package:echo_client/conversation.dart';

class MessagesPage extends StatelessWidget {
  final server = new Server();
  final Conversation conversation;
  MessagesPage(this.conversation);

  Future<void> listUsers(BuildContext context) async {
    final users = (await server.getUsers(conversation.id)).users;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text("Participants"),
              content: Container(
                width: double.maxFinite,
                child: Scrollbar(
                  child: ListView.separated(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return Column(children: <Widget>[UserTile(users[index])]);
                    },
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(conversation.name), actions: <Widget>[
          IconButton(
            icon: Icon(Icons.people),
            tooltip: 'View participants',
            onPressed: () async => await listUsers(context),
          )
        ]),
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

  _MessagesListState(this.conversation);

  Future<void> refresh() async {
    final server = new Server();
    final messages = (await server.getMessages(conversation.id)).messages;
    setState(() {
      _messagesList = messages;
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
                  final reversedIndex = _messagesList.length - index - 1;
                  return Directionality(
                      textDirection: altDirection[reversedIndex % 2],
                      child: MessageTile(_messagesList[reversedIndex]));
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

class MessageBar extends StatefulWidget {
  final Conversation _conversation;

  const MessageBar(this._conversation);

  @override
  _MessageBarState createState() => _MessageBarState(_conversation);
}

class _MessageBarState extends State<MessageBar> {
  String messageText;
  final Conversation conversation;

  _MessageBarState(this.conversation);

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

class UserTile extends StatelessWidget {
  final User _data;

  const UserTile(this._data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_data.email),
    );
  }
}
