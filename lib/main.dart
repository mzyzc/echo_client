import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Echo',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Echo'),
        ),
        body: DefaultTextStyle(
          style: TextStyle(fontSize: 20, color: Colors.black),
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text('Hello there!'),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text('Hey'),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text('How\'s it going?'),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text('Great'),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
