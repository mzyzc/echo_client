import 'package:echo_client/keys.dart';

Future<void> initNewUser() async {
  final keys = new Keyring()
    ..genKeys();
  await keys.export();
}
