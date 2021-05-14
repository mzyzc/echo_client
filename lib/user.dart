import 'dart:convert';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class User {
  String _email;
  String _password;
  Keyring _keys;

  User(this._email, this._password);
  User.simple(this._email);

  User.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
  }

  Map<String, dynamic> toJson() {
    return {
      "email": _email,
    };
  }

  String get email {
    return _email;
  }

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
          'publicKey': base64.encode(utf8
              .encode((await _keys.exchangePair.extractPublicKey()).toString()))
        }
      ]
    });

    final server = new Server();
    final response = await server.send(data);

    if (!response.isValid()) {
      throw Exception('Server rejected this request');
    }
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

    final server = new Server();
    final response = await server.send(data);

    if (!response.isValid()) {
      throw Exception('Server rejected this request');
    }
  }
}
