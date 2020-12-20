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
      child: ListView.builder(
          itemCount: 100,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text('Person ${index + 1}'),
              onTap: () {
                Navigator.pushNamed(context, '/messages');
              },
            );
          }
      ),
    );
  }
}
