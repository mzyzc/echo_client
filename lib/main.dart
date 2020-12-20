import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:echo_client/message.dart';
import 'package:echo_client/keys.dart';

void main() {
  runApp(MyApp());
  initNewUser();
}

Future<void> initNewUser() async {
  final keys = new Keyring()
  ..genKeys();
  await keys.export();
}

Future<void> newMessage() async {
  final keys = new Keyring();
  await keys.import();
  var tempSessionKey = await keys.createSessionKey(keys.exchangePair.publicKey); // for testing purposes only
  var message = new Message();
  message.initialize(utf8.encode("This is a message"), "text/plain", tempSessionKey, keys.signingPair);
  message.send();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(title: 'Echo'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MessagesPage(),
    SettingsPage(),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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
            );
          }
      ),
    );
  }
}

class MessagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ContactsList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => newMessage(),
        tooltip: 'Add contact',
        child: Icon(Icons.add),
      ),
    );
  }
  
}
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('This is the settings section'),
      ),
    );
  }
}