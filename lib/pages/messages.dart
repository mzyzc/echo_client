import 'package:flutter/material.dart';
import 'package:echo_client/logic.dart';

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('John Doe'),
      ),
      body: Center(
          child: Text('This is the messages section')
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newMessage(),
        tooltip: 'Send message',
        child: Icon(Icons.message),
      ),
    );
  }
}