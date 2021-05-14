import 'dart:convert';
import 'dart:io';
import 'package:echo_client/response.dart';

// A global object representing a connection to a server
class Server {
  // Initialize singleton
  Server._internal();

  static final Server _instance = Server._internal();

  factory Server() {
    return _instance;
  }

  String _host;
  int _port;
  String user;
  SecureSocket _socket;
  Stream _stream;

  // Initialise a connection with the server
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

  // Send data to the server and wait for a response
  Future<Response> send(Object data) async {
    this._socket.write(data);
    List<int> response = await _stream.first;

    return Response(response);
  }

  // Request all the messages in a specified conversation
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

  // Request all the conversations for a user
  Future<Response> getConversations() async {
    final request = jsonEncode({"function": "READ CONVERSATIONS"});
    return await send(request);
  }

  // Request all the users in a specified conversation
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
