import 'package:flutter/material.dart';
import 'package:echo_client/server.dart';
import 'package:echo_client/message.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var messageText;
    final altDirection = [TextDirection.rtl, TextDirection.ltr];

    final server = new Server();
    final messagesList = server.messagesTemp.messages;
    final usersList = server.usersTemp.users;

    return Scaffold(
        appBar: AppBar(
          title: Text('John Doe'),
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
                          child: ListTile(
                            title: Text(messagesList[index].messageData),
                            subtitle: Text(messagesList[index].timeSent),
                          ),
                        );
                      }))),
          Align(
              alignment: Alignment.bottomCenter,
              child: Row(children: <Widget>[
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
                    onPressed: () => newMessage(messageText),
                  ),
                )
              ])),
        ]));
  }
}
