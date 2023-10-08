import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final roomCodeProvider = FutureProvider.family<String, String>((ref, uid) async {
  final snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = snapshot.data();
  return data?['roomCode'];
});
