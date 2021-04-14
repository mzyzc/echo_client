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

  String _host;
  int _port;
  SecureSocket _socket;
  Response _data;

  void connect(String host, int port) async {
    _host = host;
    _port = port;

    _socket = await SecureSocket.connect(host, port,
        onBadCertificate: (X509Certificate cert) {
      print("Certificate warning: ${cert.issuer}:${cert.subject}");
      return false;
    });

    print('Connected to $host:${_socket.remotePort}');

    _socket.listen(
      (List<int> response) {
        _data = Response(response);
        print(String.fromCharCodes(response));
      },
      onError: (error) {
        print(error);
        _socket.destroy();
        connect(host, port);
      },
      onDone: () {
        _socket.destroy();
        connect(host, port);
      },
    );
  }

  void write(Object data) {
    this._socket.write(data);
  }

  Response read() {
    return _data;
  }
}

class Response {
  int status;
  List<Conversation> conversations;
  List<Message> messages;
  List<User> users;

  Response(List<int> data) {
    final dataString = String.fromCharCodes(data);
    final decoded = jsonDecode(dataString);

    status = decoded.status;
    conversations = List<Conversation>.from(
        decoded.conversations.map((data) => Conversation.fromJson(data)));
    messages = List<Message>.from(
        decoded.messages.map((data) => Message.fromJson(data)));
    users = List<User>.from(decoded.users.map((data) => User.fromJson(data)));
  }
}
