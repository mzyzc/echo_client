import 'package:flutter/material.dart';
import 'package:echo_client/message.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var messageText;

    final altDirection = [TextDirection.rtl, TextDirection.ltr];

    return Scaffold(
      appBar: AppBar(
        title: Text('John Doe'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Scrollbar(
              child: ListView.builder(
                reverse: true,
                itemCount: 100,
                itemBuilder: (context, index) {
                  return Directionality(
                    textDirection: altDirection[index % 2],
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Text('Message ${index + 1}'),
                    ),
                  );
                }
              )
            )
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    onChanged: (text) => messageText = text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Write a message...',
                    )
                  ),
                ),
                ElevatedButton(
                  child: Icon(Icons.send),
                  onPressed: () => newMessage(messageText),
                ),
              ]
            )
          ),
        ]
      )
    );
  }
}