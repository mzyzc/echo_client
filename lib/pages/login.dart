import 'package:flutter/material.dart';
import 'package:echo_client/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _authCode;

  @override
  Widget build(BuildContext context) {
    Future<void> login() async {
      final user = User(_email, _password);
      await user.login();
    }

    Future<void> register() async {
      final user = User(_email, _password);
      await user.register();
    }

    final inputEmail = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email *',
        ),
        onChanged: (text) => _email = text,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'This field is required';
          } else if (!isValidEmail(text)) {
            return 'Invalid email address';
          }
          return null;
        },
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Password *',
        ),
        onChanged: (text) => _password = text,
        validator: (text) {
          if (text == null || text.isEmpty) {
            return 'This field is required';
          }
          return null;
        },
      ),
    );

    final buttonLogin = ElevatedButton(
      child: Text('Login'),
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          try {
            await login();
            Navigator.pushReplacementNamed(context, '/conversations');
          } catch (e) {
            displayError(context, e);
          }
        }
      },
    );

    final buttonRegister = TextButton(
        child: Text('Register'),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            try {
              _authCode = await requestAuthCode(context);
              await register();
            } catch (e) {
              displayError(context, e);
            }
          }
        });

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputEmail,
            inputPassword,
            buttonRegister,
            buttonLogin
          ],
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    // TODO: stop using regular expressions to parse emails
    final parser = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    return parser.hasMatch(email);
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

  Future<void> displayError(BuildContext context, Exception error) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
          );
        });
  }
}
