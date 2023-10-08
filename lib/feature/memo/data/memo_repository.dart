import 'package:share_kakeibo/feature/memo/domain/memo.dart';

abstract class MemoRepository {
  // メモ一覧取得
  Stream<List<Memo>> readMemo({
    required String roomCode,
  });

  // // メモ一覧取得
  // Future<List<Memo>> readMemo({
  //   required String roomCode,
  // });

  // メモの作成
  Future<void> createMemo({
    required String roomCode,
    required String memo,
  });

  // メモの削除
  Future<void> deleteMemo({
    required String roomCode,
    required String id,
  });
}
