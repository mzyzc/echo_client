import 'package:flutter/material.dart';
import 'package:echo_client/user.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inputEmail = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
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
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );

    final buttonLogin = ElevatedButton(
      child: Text('Login'),
      onPressed: () => Navigator.pushReplacementNamed(context, '/'),
    );

    final buttonRegister = TextButton(
      child: Text('Register'),
      onPressed: () => initNewUser(),
    );

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[inputEmail, inputPassword, buttonRegister, buttonLogin]
      ),
    );
  }
}
