import 'package:flutter/material.dart';
import 'package:echo_client/user.dart';

class LoginPage extends StatelessWidget {
  var email;
  var password;
  var authCode;

  @override
  Widget build(BuildContext context) {
    final inputEmail = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) => email = text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
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
        final user = User(email, password);
        await user.login();
        Navigator.pop(context, email);
      },
    );

    final buttonRegister = TextButton(
        child: Text('Register'),
        onPressed: () async {
          authCode = await requestAuthCode(context);
          final user = User(email, password);
          await user.register();
        });

    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputEmail,
            inputPassword,
            buttonRegister,
            buttonLogin
          ]),
    );
  }

  Future<String> requestAuthCode(BuildContext context) {
    var authCode;

    final inputAuthCode = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) => authCode = text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Authentication code',
        ),
      ),
    );

    final buttonSubmit = TextButton(
      child: Text('Submit'),
      onPressed: () => Navigator.pop(context, authCode),
    );

    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("Authentication Code"),
            children: <Widget>[inputAuthCode, buttonSubmit],
          );
        });
  }
}
