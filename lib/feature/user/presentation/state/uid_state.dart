import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ユーザーのID
final uidProvider = StateProvider<String>(
  (ref) => FirebaseAuth.instance.currentUser!.uid,
);
