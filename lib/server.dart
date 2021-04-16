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

  Response get messagesTemp {
    return DummyServer.messages;
  }

  Response get conversationsTemp {
    return DummyServer.conversations;
  }

  Response get usersTemp {
    return DummyServer.users;
  }
}
