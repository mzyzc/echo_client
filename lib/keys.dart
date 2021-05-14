import 'dart:io';
import 'dart:math';
import 'package:cryptography/cryptography.dart';
import 'package:path_provider/path_provider.dart';
import 'package:echo_client/server.dart';

class Keyring {
  KeyPair exchangePair;
  List<int> _exchangeSeed;
  KeyPair signaturePair;
  List<int> _signatureSeed;

  Future<void> genKeys() async {
    exchangePair = await _createExchangePair();
    signaturePair = await _createSigningPair();
  }

  Future<KeyPair> _createExchangePair() async {
    _exchangeSeed = genSeed(32);
    return await X25519().newKeyPairFromSeed(_exchangeSeed);
  }

  Future<KeyPair> _createSigningPair() async {
    _signatureSeed = genSeed(32);
    return await Ed25519().newKeyPairFromSeed(_signatureSeed);
  }

  List<int> genSeed(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (i) => random.nextInt(255));
  }

  Future<SecretKey> createSessionKey(PublicKey remoteKey) async {
    return await X25519().sharedSecretKey(
      keyPair: exchangePair,
      remotePublicKey: remoteKey,
    );
  }

  Future<void> import() async {
    final dataDir = await getApplicationSupportDirectory();
    final server = new Server();

    final exchangeFile =
        File('${dataDir.path}/${server.user}-exchangeSeed.key');
    final signatureFile =
        File('${dataDir.path}/${server.user}-signatureSeed.key');

    final exchangeFileBytes = await exchangeFile.readAsBytes();
    final signatureFileBytes = await signatureFile.readAsBytes();

    exchangePair = await X25519().newKeyPairFromSeed(exchangeFileBytes);
    signaturePair = await Ed25519().newKeyPairFromSeed(signatureFileBytes);
  }

  Future<void> export() async {
    final dataDir = await getApplicationSupportDirectory();
    final server = new Server();

    final exchangeFile =
        File('${dataDir.path}/${server.user}-exchangeSeed.key');
    final signatureFile =
        File('${dataDir.path}/${server.user}-signatureSeed.key');

    await exchangeFile.writeAsBytes(_exchangeSeed);
    await signatureFile.writeAsBytes(_signatureSeed);
  }
}
