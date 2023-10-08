import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/constant/img_url.dart';
import 'package:share_kakeibo/feature/login/data/login_repository.dart';
import 'package:share_kakeibo/feature/memo/data/memo_repository.dart';
import 'package:share_kakeibo/importer.dart';

final memoRepositoryProvider = Provider(
  (ref) => MemoRepositoryImpl(),
);

class MemoRepositoryImpl extends MemoRepository {
  // 利用する外部サービスの指定
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Memo>> readMemo({
    required String roomCode,
  }) {
    try {
      // 初期状態は降順
      final collection =
          _firestore.collection('users').doc(roomCode).collection('memo');
      return collection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return Memo.fromJson(data);
        }).toList();
      });
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  // @override
  // Future<List<Memo>> readMemo({
  //   required String roomCode,
  // }) async {
  //   try {
  //     final memoList = <Memo>[];
  //     // 初期状態は降順
  //     final collection = _firestore
  //         .collection('users').doc(roomCode).collection('memo');
  //     await collection.get().then(
  //       (querySnapshot) {
  //         for (final doc in querySnapshot.docs) {
  //           final data = doc.data();
  //           data['id'] = doc.id;
  //           final memo = Memo.fromJson(data);
  //           memoList.add(memo);
  //         }
  //       },
  //     );
  //     return memoList;
  //   } on FirebaseException catch (e) {
  //     logger.e(e);
  //     rethrow;
  //   } on Exception catch (e) {
  //     logger.e(e);
  //     rethrow;
  //   }
  // }

  @override
  Future<void> createMemo({
    required String roomCode,
    required String memo,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(roomCode)
          .collection('memo')
          .add({
        'memo': memo,
        'registerDate': DateTime.now(),
      });
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteMemo({
    required String roomCode,
    required String id,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(roomCode)
          .collection('memo')
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
