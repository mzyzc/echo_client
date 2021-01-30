import 'dart:io';

class Server {
  static String host;
  static SecureSocket socket;

  static init(String host) async {
    Server.host = host;
    Server.socket = await SecureSocket.connect(host, 63100,
        onBadCertificate: (X509Certificate cert) {
      print("Certificate warning: ${cert.issuer}:${cert.subject}");
      return false;
    });
    print('Connected to $host:63100');
  }
}
