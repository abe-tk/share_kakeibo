import 'package:cloud_firestore/cloud_firestore.dart';

// メモの一覧を取得
Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getMemoFire(String roomCode) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('memo').get();
  return snapshot.docs;
}

// メモの追加
Future<void> addMemoFire(String roomCode, String memo) async {
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('memo').add({
    'memo': memo,
    'registerDate': DateTime.now(),
  });
}

// メモの削除
Future<void> deleteMemoFire(String roomCode, String id) async {
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('memo').doc(id).delete();
}
