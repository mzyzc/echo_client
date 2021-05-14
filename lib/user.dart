import 'dart:convert';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

// Represents a user in Echo
class User {
  String _email;
  String _password;
  Keyring _keys;

  // The user class can be used for both existing users and newly registered ones
  User(this._email, this._password);
  User.simple(this._email);

  // Create a user object from JSON
  User.fromJson(Map<String, dynamic> json) {
    _email = json['email'];
  }

  // Translate a user object to JSON
  Map<String, dynamic> toJson() {
    return {
      "email": _email,
    };
  }

  String get email {
    return _email;
  }

  // Set up a new user and request the server to register them
  Future<void> register() async {
    final server = new Server();
    server.user = _email;

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

    final response = await server.send(data);

    // Responses with invalid codes get thrown out
    if (!response.isValid()) {
      throw Exception('Server rejected this request');
    }
  }

  // Login and validate an existing user
  Future<void> login() async {
    final server = new Server();
    server.user = _email;

    final data = jsonEncode({
      "function": "VERIFY USERS",
      'users': [
        {
          "email": _email,
          "password": _password,
        }
      ]
    });

    final response = await server.send(data);

    if (!response.isValid()) {
      throw Exception('Server rejected this request');
    }
  }
}
