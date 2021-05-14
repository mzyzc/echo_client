import 'package:flutter/material.dart';
import 'package:echo_client/server.dart';
import 'package:echo_client/conversation.dart';
import 'package:echo_client/user.dart';

// A list of conversations a user is in
class ConversationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConversationsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => await addConversation(context),
        tooltip: 'Add contact',
        child: Icon(Icons.add),
      ),
    );
  }

  // Adding a user to a conversation
  Future<void> addConversation(BuildContext context) {
    String title;
    List<String> emails;
    List<User> participants;

    // Title input for a dialog
    final inputTitle = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) => title = text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name the conversation',
        ),
      ),
    );

    // Email input for a dialog
    final inputEmails = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) => emails = text.split(' '),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Enter emails (space-separated)',
        ),
      ),
    );

    // Submit button for a dialog
    final buttonSubmit = TextButton(
        child: Text('Submit'),
        onPressed: () {
          participants =
              new List<User>.from(emails.map((email) => User.simple(email)));
          Conversation.create(title, participants);
          Navigator.pop(context);
        });

    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Create a conversation"),
            children: <Widget>[inputTitle, inputEmails, buttonSubmit],
          );
        });
  }
}

class ConversationsList extends StatefulWidget {
  @override
  _ConversationsListState createState() => _ConversationsListState();
}

// Manages changes in user's list of conversations
class _ConversationsListState extends State<ConversationsList> {
  List<Conversation> _conversationList = [];

  Future<void> refresh() async {
    final server = new Server();
    final conversations = (await server.getConversations()).conversations;
    setState(() => _conversationList = conversations);
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Scrollbar(
          child: ListView.separated(
            itemCount: _conversationList.length,
            itemBuilder: (context, index) {
              return Column(children: <Widget>[
                ConversationTile(_conversationList[index])
              ]);
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
        onRefresh: refresh);
  }
}

// Representation of a single conversation
class ConversationTile extends StatelessWidget {
  final Conversation _data;

  const ConversationTile(this._data);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text(_data.name),
      onTap: () {
        Navigator.pushNamed(context, '/messages', arguments: _data);
      },
    );
  }
}
