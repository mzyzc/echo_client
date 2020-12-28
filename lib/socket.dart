import 'dart:io';

class DataSocket {
  static String host;
  static Socket socket;
  
  static init(String host) async {
    DataSocket.host = host;
    DataSocket.socket = await Socket.connect(host, 63100);
    print('Connected to ${host}:63100');
  }
}

