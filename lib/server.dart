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

  Response messagesTemp(int conversationId) {
    final request = jsonEncode({
      "function": "READ MESSAGES",
      "conversations": [
        {
          "id": conversationId,
        }
      ]
    });
    write(request);

    return DummyServer.messages;
  }

  Response conversationsTemp() {
    /*
    final request = jsonEncode({"function": "READ CONVERSATIONS"});
    write(request);
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
    write(request);

    return DummyServer.users;
  }
}
