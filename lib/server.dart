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
  int port;
  SecureSocket _socket;

  void connect(String host, int port) async {
    this.host = host;
    this.port = port;
    this._socket = await SecureSocket.connect(host, port,
        onBadCertificate: (X509Certificate cert) {
      print("Certificate warning: ${cert.issuer}:${cert.subject}");
      return false;
    });

    print('Connected to $host:${this._socket.remotePort}');

    /* */
    this._socket.listen((var data) => print(data));
    /* */
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
      this.connect(host, port);
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
