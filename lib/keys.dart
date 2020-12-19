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
}