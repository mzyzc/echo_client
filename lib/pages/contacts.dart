import 'package:flutter/material.dart';

class ContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ContactsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => print('Contact added'),
        tooltip: 'Add contact',
        child: Icon(Icons.add),
      ),
    );
  }
}
class ContactsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        itemCount: 100,
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text('John Doe'),
                onTap: () {
                  Navigator.pushNamed(context, '/messages');
                },
              )
            ]
          );
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
