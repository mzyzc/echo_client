import 'dart:io';
import 'package:cryptography_flutter/cryptography_flutter.dart';
import 'package:cryptography/cryptography.dart';
import 'package:path_provider/path_provider.dart';

class Keyring {
  KeyPair exchangePair;
  KeyPair signingPair;

  Future<void> genKeys() async {
    exchangePair = await _createExchangePair();
    signingPair = await _createSigningPair();
  }

  Future<KeyPair> _createExchangePair() async {
    return await x25519.newKeyPair();
  }

  Future<KeyPair> _createSigningPair() async {
    return await ed25519.newKeyPair();
  }

  Future<SecretKey> createSessionKey(PublicKey remoteKey) async {
    return await x25519.sharedSecret(
      localPrivateKey: exchangePair.privateKey,
      remotePublicKey: remoteKey,
    );
  }

  Future<void> import() async {
    final dataDir = await getApplicationDocumentsDirectory();

    final exPrFile = File('${dataDir.path}/privateExchange.key');
    final exPuFile = File('${dataDir.path}/publicExchange.key');
    final siPrFile = File('${dataDir.path}/privateSign.key');
    final siPuFile = File('${dataDir.path}/publicSign.key');

    exchangePair = KeyPair(
        privateKey: PrivateKey(await exPrFile.readAsBytes()),
        publicKey: PublicKey(await exPuFile.readAsBytes()));
    signingPair = KeyPair(
        privateKey: PrivateKey(await siPrFile.readAsBytes()),
        publicKey: PublicKey(await siPuFile.readAsBytes()));
  }

  Future<void> export() async {
    final dataDir = await getApplicationDocumentsDirectory();

    final exPrFile = File('${dataDir.path}/privateExchange.key');
    final exPuFile = File('${dataDir.path}/publicExchange.key');
    final siPrFile = File('${dataDir.path}/privateSign.key');
    final siPuFile = File('${dataDir.path}/publicSign.key');

    exPrFile.writeAsBytes(await exchangePair.privateKey.extract());
    exPuFile.writeAsBytes(exchangePair.publicKey.bytes);
    siPrFile.writeAsBytes(await signingPair.privateKey.extract());
    siPuFile.writeAsBytes(signingPair.publicKey.bytes);
  }
}
