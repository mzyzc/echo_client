//import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:flutter/material.dart';
import 'package:echo_client/pages/conversations.dart';
import 'package:echo_client/pages/login.dart';
import 'package:echo_client/pages/messages.dart';
import 'package:echo_client/pages/settings.dart';
import 'package:echo_client/server.dart';

void main() {
  //FlutterCryptography.enable();
  final server = new Server();
  server.connect('czyz.xyz', 63100);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/conversations': (context) => HomePage(title: 'Echo'),
        '/messages': (context) =>
            MessagesPage(ModalRoute.of(context).settings.arguments),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;

  const HomePage({Key key, this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    ConversationsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    const navConversations = BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Conversations',
    );

    const navSettings = BottomNavigationBarItem(
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
        items: <BottomNavigationBarItem>[navConversations, navSettings],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
