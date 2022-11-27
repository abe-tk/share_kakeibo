import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final memoProvider =
StateNotifierProvider<MemoNotifier, List<Memo>>((ref) {
  return MemoNotifier();
});

class MemoNotifier extends StateNotifier<List<Memo>> {
  MemoNotifier() : super([]);

  late String roomCode;

  Future<void> setMemo() async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> memos = [];
    roomCode = await getRoomCodeFire(uid);
    memos = await getMemoFire(roomCode);
    state = memos.map((doc) => Memo(
      id: doc.id,
      memo: doc['memo'],
      date: (doc['registerDate'] as Timestamp).toDate(),
      completed: false,
    ))
        .toList();
    state.sort((a, b) => a.date.compareTo(b.date));
  }

  void toggle(String memoId) {
    state = [
      for (final memo in state)
        if (memo.id == memoId)
          memo.copyWith(completed: !memo.completed)
        else
          memo,
    ];
  }

  Future<void> addMemo(String memo) async {
    memoValidation(memo);
    addMemoFire(roomCode, memo);
    await setMemo();
  }

  Future<void> removeMemo() async {
    bool value = false;
    for (final memo in state) {
      if (memo.completed == true) {
        value = true;
        break;
      }
    }
    switch(value) {
      case true:
        for (final memo in state) {
          if (memo.completed == true) {
            deleteMemoFire(roomCode, memo.id);
          }
        }
        break;
      default:
        throw '削除するメモが選択されていません';
    }
    await setMemo();
  }

}