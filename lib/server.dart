import 'dart:io';
import 'dart:convert';
import 'package:echo_client/message.dart';
import 'package:echo_client/user.dart';
import 'package:echo_client/conversation.dart';

class Server {
  // Initialize singleton
  Server._internal();

  static final Server _instance = Server._internal();

  factory Server() {
    return _instance;
  }

  String host;
  SecureSocket _socket;

  void connect(String host) async {
    this.host = host;
    this._socket = await SecureSocket.connect(host, 63100,
        onBadCertificate: (X509Certificate cert) {
      print("Certificate warning: ${cert.issuer}:${cert.subject}");
      return false;
    });

    print('Connected to $host:${this._socket.remotePort}');
  }

  void write(Object data) {
    this._socket.write(data);
  }

  String listen() {
    var response = '';

    this._socket.listen((List<int> data) {
      response = String.fromCharCodes(data);
    }, onError: (error) {
      print(error);
      this._socket.destroy();
      this.connect(host);
    }, onDone: () {
      this._socket.flush();
      this._socket.close();
    });

    return response;
  }
}

class Response {
  int status;
  List<Conversation> conversations;
  List<Message> messages;
  List<User> users;

  static Response fromJson(String data) {
    final decoded = jsonDecode(data);

    final response = new Response();
    response.status = decoded.status;
    response.conversations = decoded.conversations;
    response.messages = decoded.messages;
    response.users = decoded.users;

    return response;
  }
}
