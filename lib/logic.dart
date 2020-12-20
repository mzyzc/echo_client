import 'dart:convert';
import 'package:cryptography_flutter/cryptography.dart';
import 'package:echo_client/message.dart';
import 'package:echo_client/keys.dart';

Future<void> initNewUser() async {
  final keys = new Keyring()
    ..genKeys();
  await keys.export();
}

Future<void> newMessage() async {
  final keys = new Keyring();
  await keys.import();
  final tempSessionKey = await keys.createSessionKey(keys.exchangePair.publicKey); // for testing purposes only

  final message = new Message();
  await message.initialize(utf8.encode("This is a message"), "text/plain", tempSessionKey, keys.signingPair);
  await message.sign(keys.signingPair);
  message.send();
}
