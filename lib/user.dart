import 'dart:convert';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class User {
  String _email;
  String _password;
  Keyring _keys;

  User(this._email, this._password);

  Future<void> register() async {
    _keys = new Keyring();
    await _keys.genKeys();
    await _keys.export();

    final data = jsonEncode({
      'function': 'CREATE USERS',
      'users': [
        {
          'email': _email,
          'password': _password,
          'publicKey': base64.encode(_keys.exchangePair.publicKey.bytes)
        }
      ]
    });
    print(data);

    final server = new Server();
    server.write(data);
  }

  Future<void> login() async {
    final data = jsonEncode({
      "function": "VERIFY USERS",
      'users': [
        {
          "email": _email,
          "password": _password,
        }
      ]
    });
    print(data);

    final server = new Server();
    server.write(data);
  }
}
