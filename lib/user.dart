import 'dart:convert';
import 'package:echo_client/keys.dart';
import 'package:echo_client/server.dart';

class User {
  String _email;
  String _password;
  String _displayName;
  Keyring _keys;

  User(this._email, this._password, this._displayName);

  static Future<void> registerUser(
      String username, String password, String displayName) async {
    final user = User(username, password, displayName);
    await user.register();
  }

  static Future<void> loginUser(String username, String password) async {
    final user = User(username, password, 'placeholder');
    await user.login();
  }

  Future<void> register() async {
    _keys = new Keyring();
    await _keys.genKeys();
    await _keys.export();

    final data = jsonEncode({
      'function': 'CREATE USER',
      'email': _email,
      'displayName': _displayName,
      'password': _password,
      'publicKey': base64.encode(_keys.exchangePair.publicKey.bytes)
    });
    print(data);
    Server.socket.write(data);
  }

  Future<void> login() async {
    final data = jsonEncode({
      "function": "VERIFY USER",
      "email": _email,
      "password": _password,
    });
    print(data);
    Server.socket.write(data);
  }
}
