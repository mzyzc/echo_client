import 'package:flutter/material.dart';
import 'package:echo_client/user.dart';

class LoginPage extends StatelessWidget {
  String _email;
  String _password;
  String _authCode;

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      final user = User(_email, _password);
      await user.login();
    }

    final inputEmail = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (text) => _email = text,
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
        onChanged: (text) => _password = text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password',
        ),
      ),
    );

    final buttonLogin = ElevatedButton(
      child: Text('Login'),
      onPressed: () async {
        await login();
        Navigator.pushReplacementNamed(context, '/conversations');
      },
    );

    final buttonRegister = TextButton(
        child: Text('Register'),
        onPressed: () async {
          _authCode = await requestAuthCode(context);
          final user = User(_email, _password);
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
    String authCode;

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
