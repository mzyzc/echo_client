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
                      title: Text('This is an example message functioning as a proof of concept'),
                      subtitle: Text('11:32'),
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
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (text) => messageText = text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Write a message...',
                      )
                    ),
                  )
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child:ElevatedButton(
                    child: Icon(Icons.send),
                    onPressed: () => newMessage(messageText),
                  ),
                )
              ]
            )
          ),
        ]
      )
    );
  }
}