import 'dart:convert';
import 'dart:io';
//import 'package:echo_client/dummy_server.dart';
import 'package:echo_client/response.dart';
import 'package:echo_client/user.dart';
import 'package:echo_client/conversation.dart';
import 'package:echo_client/message.dart';

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
  Stream _stream;

  void connect(String host, int port) async {
    _host = host;
    _port = port;

    _socket = await SecureSocket.connect(_host, _port,
        onBadCertificate: (X509Certificate cert) {
      print("Certificate warning: ${cert.issuer}:${cert.subject}");
      return false;
    });

    print('Connected to $host:${_socket.remotePort}');

    _stream = _socket.asBroadcastStream();
  }

  Future<Response> send(Object data) async {
    this._socket.write(data);
    List<int> response = await _stream.first;

    return Response(response);
  }

  Future<Response> getMessages(int conversationId) async {
    final request = jsonEncode({
      "function": "READ MESSAGES",
      "conversations": [
        {
          "id": conversationId,
        }
      ]
    });
    return await send(request);
  }

  Future<Response> getConversations() async {
    final request = jsonEncode({"function": "READ CONVERSATIONS"});
    return await send(request);
  }

  Future<Response> getUsers(int conversationId) async {
    final request = jsonEncode({
      "function": "READ USERS",
      "conversations": [
        {
          "id": conversationId,
        }
      ]
    });
    return await send(request);
  }
}
