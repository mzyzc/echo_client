import 'dart:convert';
import 'dart:io';
//import 'package:echo_client/dummy_server.dart';
import 'package:echo_client/response.dart';

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

    _socket = await SecureSocket.connect(_host, _port,
        onBadCertificate: (X509Certificate cert) {
      print("Certificate warning: ${cert.issuer}:${cert.subject}");
      return false;
    });

    print('Connected to $host:${_socket.remotePort}');

    _socket.listen(
      (List<int> response) async {
        print(String.fromCharCodes(response));
        _data = Response(response);
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

  Future<Response> write(Object data) async {
    _socket.write(data);

    Response output = _data;
    while (output == null) {
      print(output);
      output = _data;
    }

    return output;
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
    return await write(request);

    //return DummyServer.messages;
  }

  Future<Response> getConversations() async {
    final request = jsonEncode({"function": "READ CONVERSATIONS"});
    return await write(request);

    //return DummyServer.conversations;
  }

  Future<Response> usersTemp(int conversationId) async {
    final request = jsonEncode({
      "function": "READ USERS",
      "conversations": [
        {
          "id": conversationId,
        }
      ]
    });
    return await write(request);

    //return DummyServer.users;
  }
}
