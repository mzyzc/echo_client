import 'dart:convert';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class User {
  String email;
  String _password;
  String displayName;
  Keyring _keys;

  User(this.email, this._password, this.displayName);

  Future<void> register() async {
    _keys = new Keyring()
      ..genKeys();
    await _keys.export();

    final data = jsonEncode('''
      "CREATE USER" [
        {
          "email": "${this.email}",
          "password": "${this._password}",
          "publicKey": "${this._keys.exchangePair.publicKey}",
          "displayName": "${this.displayName}",
        }
      ]
    ''');
    Server.socket.write(data);
  }

  Future<void> login() async {
    final data = jsonEncode('''
      "READ USER" [
        {
          "email": "${this.email}",
          "password": "${this._password}",
        }
      ]
    ''');
    Server.socket.write(data);
  }
}

void registerUser(String username, String password, String displayName) {
  final newUser = User(username, password, displayName)
      ..register;
  print("user ${newUser.displayName} registered with email ${newUser.email}");
}