import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

// ルームコードの取得
final roomCodeProvider = FutureProvider<String>((ref) async {
  final uid = ref.watch(uidProvider);
  final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = snapshot.data();
  return data!['roomCode'];
});
