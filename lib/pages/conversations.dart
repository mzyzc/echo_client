import 'package:flutter/material.dart';
import 'package:echo_client/server.dart';

class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConversationsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('Contact added'),
        tooltip: 'Add contact',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ConversationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final server = new Server();
    final conversationList = server.conversationsTemp().conversations;

    return Scrollbar(
      child: ListView.separated(
        itemCount: conversationList.length,
        itemBuilder: (context, index) {
          return Column(children: <Widget>[
            ListTile(
              leading: Icon(Icons.person),
              title: Text(conversationList[index].name),
              onTap: () {
                Navigator.pushNamed(context, '/messages',
                    arguments: conversationList[index]);
              },
            )
          ]);
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
