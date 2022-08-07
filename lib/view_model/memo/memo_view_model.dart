/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// model
import 'package:share_kakeibo/model/memo.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final memoViewModelProvider = ChangeNotifierProvider((ref) => MemoViewModel());

class MemoViewModel extends ChangeNotifier {
  late String roomCode;
  String? memo;
  List<Memo> memoList = [];
  final memoController = TextEditingController();

  Future<void> fetchMemo() async {
    final codeSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = codeSnapshot.data();
    roomCode = data?['roomCode'];

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('memo')
        .get();

    final memos = snapshot.docs.map((snapshot) => Memo(snapshot)).toList();
    memos.sort((a, b) => a.date.compareTo(b.date));
    memoList = memos;

    notifyListeners();
  }

  void setMemo(String memo) {
    this.memo = memo;
  }

  void clearMemo() {
    memoController.clear();
  }

  Future<void> addMemo() async {
    memo = memoController.text;

    if (memo == null || memo == "") {
      throw 'メモが入力されていません';
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('memo')
        .add({
      'memo': memo,
      'registerDate': DateTime.now(),
    });
  }
}
