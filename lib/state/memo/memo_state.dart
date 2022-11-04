// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
import 'package:share_kakeibo/firebase/memo_fire.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<QueryDocumentSnapshot<Map<String, dynamic>>> memos = [];

final memoProvider =
StateNotifierProvider<MemoNotifier, List<QueryDocumentSnapshot<Map<String, dynamic>>>>((ref) {
  return MemoNotifier();
});

class MemoNotifier extends StateNotifier<List<QueryDocumentSnapshot<Map<String, dynamic>>>> {
  MemoNotifier() : super(memos);

  late String roomCode;

  Future<void> setMemo() async {
    roomCode = await setRoomCodeFire(uid);
    memos = await getMemoFire(roomCode);
    state = memos;
  }

}