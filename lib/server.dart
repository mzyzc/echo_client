import 'dart:convert';
import 'dart:io';
import 'package:echo_client/dummy_server.dart';
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
  Stream _stream;
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

    _stream = _socket.asBroadcastStream();
  }

  Future<Response> send(Object data) async {
    /*
    var subscription = await _socket.listen(
      (List<int> response) {
        print(String.fromCharCodes(response));
        _data = Response(response);
      },
      onError: (error) {
        print(error);
        _socket.destroy();
        connect(_host, _port);
      },
    );
    */

    this._socket.write(data);
    List<int> response = await _stream.first;

    return Response(response);
  }

  Response messagesTemp(int conversationId) {
    final request = jsonEncode({
      "function": "READ MESSAGES",
      "conversations": [
        {
          "id": conversationId,
        }
      ]
    });
    send(request);

    return DummyServer.messages;
  }

  Response conversationsTemp() {
    /*
    final request = jsonEncode({"function": "READ CONVERSATIONS"});
    send(request);
    */

    return DummyServer.conversations;
  }

  Response usersTemp(int conversationId) {
    final request = jsonEncode({
      "function": "READ USERS",
      "conversations": [
        {
          "id": conversationId,
        }
      ]
    });
    send(request);

    return DummyServer.users;
  }
}
