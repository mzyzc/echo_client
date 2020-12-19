import 'package:echo_client/message.dart';
import 'package:echo_client/keys.dart';

Future<void> initNewUser() async {
  var keys = new Keyring()
  ..genKeys();
  print('exPub: ${keys.exchangePair.publicKey.toString()}');
  print('exPri: ${keys.exchangePair.privateKey.toString()}');
  print('siPub: ${keys.signingPair.publicKey.toString()}');
  print('siPri: ${keys.signingPair.privateKey.toString()}');
  //var tempSessionKey = await keys.createSessionKey(keys.exchangePair.publicKey); // for testing purposes only
  //var message = new Message();
  //await message.initialize("This is a message", "text/plain", tempSessionKey, keys.signingPair);
  //print(message.text);
  //message.send();
}