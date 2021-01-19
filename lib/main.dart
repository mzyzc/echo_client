import 'package:flutter/material.dart';
import 'package:echo_client/pages/contacts.dart';
import 'package:echo_client/pages/login.dart';
import 'package:echo_client/pages/messages.dart';
import 'package:echo_client/pages/settings.dart';
import 'package:echo_client/server.dart';

void main() {
  Server.init('czyz.xyz');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      initialRoute: '/login',
      routes: {
        '/': (context) => HomePage(title: 'Echo'),
        '/login': (context) => LoginPage(),
        '/messages': (context) => MessagesPage(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
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
    ContactsPage(),
    SettingsPage(),
  ];
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final navContacts = BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Contacts',
    );

    final navSettings = BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    );

    return Scaffold(
      appBar: AppBar(
          title: Text(widget.title),
        ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[navContacts, navSettings],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
