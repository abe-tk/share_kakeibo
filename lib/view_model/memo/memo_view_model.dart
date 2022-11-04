// components
import 'package:share_kakeibo/firebase/auth_fire.dart';
// firebase
import 'package:share_kakeibo/firebase/memo_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// state
import 'package:share_kakeibo/state/memo/memo_state.dart';
// model
import 'package:share_kakeibo/model/memo/memo.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final memoViewModelProvider =
StateNotifierProvider<MemoViewModelNotifier, List<Memo>>((ref) {
  return MemoViewModelNotifier();
});

class MemoViewModelNotifier extends StateNotifier<List<Memo>> {
  MemoViewModelNotifier() : super([]);

  late String roomCode;
  String? memo;

  void setMemo(String memo) {
    this.memo = memo;
  }

  void clearMemo() {
    memo = null;
  }

  void validationMemo() {
    if (memo == null || memo == "") {
      throw 'メモが入力されていません';
    }
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

  bool isCompletedChange() {
    bool completed = false;
    for (final memo in state) {
      if (memo.completed == true) {
        completed = true;
        break;
      }
    }
    return completed;
  }

  Future<void> fetchMemo() async {
    roomCode = await setRoomCodeFire(uid);
    final List<Memo> memos = MemoNotifier().state.map((doc) => Memo(
      id: doc.id,
      memo: doc['memo'],
      date: (doc['registerDate'] as Timestamp).toDate(),
      completed: false,
    ))
        .toList();
    memos.sort((a, b) => a.date.compareTo(b.date));
    state = memos;
  }

  Future<void> addMemo() async {
    validationMemo();
    addMemoFire(roomCode, memo!);
    await MemoNotifier().setMemo();
    fetchMemo();
  }

  Future<void> removeMemo() async {
    for (final memo in state) {
      if (memo.completed == true) {
        deleteMemoFire(roomCode, memo.id);
      }
    }

    state = [
      for (final memo in state)
        if (memo.completed != true) memo,
    ];
  }

}

