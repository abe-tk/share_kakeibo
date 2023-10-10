import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/memo/data/memo_repository.dart';
import 'package:share_kakeibo/importer.dart';

final memoRepositoryProvider = Provider(
  (ref) => MemoRepositoryImpl(),
);

class MemoRepositoryImpl extends MemoRepository {
  // 利用する外部サービスの指定
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Memo>> readMemo({
    required String roomCode,
  }) async {
    try {
      final memos = <Memo>[];
      final collection =
          _firestore.collection('users').doc(roomCode).collection('memo');
      await collection.get().then(
        (querySnapshot) {
          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            data['id'] = doc.id;
            final memo = Memo.fromJson(data);
            memos.add(memo);
          }
        },
      );
      // 昇順(登録日)に並び替え
      memos.sort(((a, b) => a.registerDate.compareTo(b.registerDate)));
      return memos;
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

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
