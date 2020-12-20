import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:cryptography_flutter/cryptography.dart';

class Keyring {
  KeyPair exchangePair;
  KeyPair signingPair;

  Future<void> genKeys() async {
    exchangePair = await _createExchangePair();
    print('Exchange key pair generated!');
    signingPair = await _createSigningPair();
    print('Signing key pair generated!');
  }
  Future<KeyPair> _createExchangePair() async {
    final exchangeKeyPair = await x25519.newKeyPair();
    return exchangeKeyPair;
  }
  Future<KeyPair> _createSigningPair() async {
    final signingKeyPair = await ed25519.newKeyPair();
    return signingKeyPair;
  }
  Future<SecretKey> createSessionKey(PublicKey remoteKey) async {
    var sessionKey = await x25519.sharedSecret(
      localPrivateKey: exchangePair.privateKey,
      remotePublicKey: remoteKey,
    );
    return sessionKey;
  }
  Future<void> import() async {
    Directory dataDir = await getApplicationDocumentsDirectory();

    var exPrFile = File('${dataDir.path}/privateExchange.key');
    var exPuFile = File('${dataDir.path}/publicExchange.key');
    var siPrFile = File('${dataDir.path}/privateSign.key');
    var siPuFile = File('${dataDir.path}/publicSign.key');

    exchangePair = KeyPair(privateKey: PrivateKey(await exPrFile.readAsBytes()),
        publicKey: PublicKey(await exPuFile.readAsBytes()));
    signingPair = KeyPair(privateKey: PrivateKey(await siPrFile.readAsBytes()),
        publicKey: PublicKey(await siPuFile.readAsBytes()));
  }
  Future<void> export() async {
    Directory dataDir = await getApplicationDocumentsDirectory();

    var exPrFile = File('${dataDir.path}/privateExchange.key');
    var exPuFile = File('${dataDir.path}/publicExchange.key');
    var siPrFile = File('${dataDir.path}/privateSign.key');
    var siPuFile = File('${dataDir.path}/publicSign.key');

    exPrFile.writeAsBytes(await exchangePair.privateKey.extract());
    exPuFile.writeAsBytes(exchangePair.publicKey.bytes);
    siPrFile.writeAsBytes(await signingPair.privateKey.extract());
    siPuFile.writeAsBytes(signingPair.publicKey.bytes);
  }
}