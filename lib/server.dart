import 'dart:io';

class Server {
  static String host;
  static Socket socket;
  
  static init(String host) async {
    Server.host = host;
    Server.socket = await Socket.connect(host, 63100);
    print('Connected to ${host}:63100');
  }
}

