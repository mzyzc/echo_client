import 'package:flutter/material.dart';
import 'package:echo_client/user.dart';

class LoginPage extends StatelessWidget {
  var username;
  var password;
  var displayName;

  @override
  Widget build(BuildContext context) {
    final inputEmail = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) => username = text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Username',
        ),
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        obscureText: true,
        onChanged: (text) => password = text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );

    final buttonLogin = ElevatedButton(
      child: Text('Login'),
      onPressed: () async {
        await loginUser(username, password);
        Navigator.pushReplacementNamed(context, '/');
      },
    );

    final buttonRegister = TextButton(
      child: Text('Register'),
      onPressed: () async {
        displayName = await requestDisplayName(context);
        await registerUser(username, password, displayName);
        Navigator.pushReplacementNamed(context, '/');
      }
    );

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[inputEmail, inputPassword, buttonRegister, buttonLogin]
      ),
    );
  }
}

Future<String> requestDisplayName(BuildContext context) {
  var displayName;

  final inputDisplayName = Padding(
    padding: EdgeInsets.all(8.0),
    child: TextField(
      onChanged: (text) => displayName = text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Display name',
      ),
    ),
  );

  final buttonSubmit = TextButton(
    child: Text('Submit'),
    onPressed: () => Navigator.pop(context, displayName),
  );

  return showDialog (
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text("Display Name"),
        children: <Widget>[inputDisplayName, buttonSubmit],
      );
    }
  );
}
