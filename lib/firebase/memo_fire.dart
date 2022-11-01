import 'package:share_kakeibo/model/memo/memo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final fire = FirebaseFirestore.instance.collection('users');

// メモの一覧を取得
Future<List<Memo>> setMemoFire(String roomCode) async {
  final snapshot = await fire.doc(roomCode).collection('memo').get();
  final List<Memo> memos = snapshot.docs
      .map((doc) => Memo(
            id: doc.id,
            memo: doc['memo'],
            date: (doc['registerDate'] as Timestamp).toDate(),
            completed: false,
          ))
      .toList();
  memos.sort((a, b) => a.date.compareTo(b.date));
  return memos;
}

// メモの追加
Future<void> addMemoFire(String roomCode, String memo) async {
  await fire.doc(roomCode).collection('memo').add({
    'memo': memo,
    'registerDate': DateTime.now(),
  });
}

// メモの削除
Future<void> deleteMemoFire(String roomCode, String id) async {
  await fire.doc(roomCode).collection('memo').doc(id).delete();
}
