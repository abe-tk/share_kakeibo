import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class AsyncMemos extends AsyncNotifier<List<Memo>> {
  // メモ一覧の取得
  Future<List<Memo>> readMemo() async {
    final repository = ref.watch(memoRepositoryProvider);
    final roomCode = await ref.watch(roomCodeProvider.future);
    return repository.readMemo(roomCode: roomCode);
  }

  // 初期データの読み込み
  @override
  FutureOr<List<Memo>> build() async {
    return await readMemo();
  }

  // メモの追加
  Future<void> createMemo({
    required String memo,
  }) async {
    final repository = ref.watch(memoRepositoryProvider);
    final roomCode = await ref.watch(roomCodeProvider.future);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.createMemo(
        roomCode: roomCode,
        memo: memo,
      );
      return readMemo();
    });
  }

  // メモの削除
  Future<void> deleteMemo({
    required String id,
  }) async {
    final repository = ref.watch(memoRepositoryProvider);
    final roomCode = await ref.watch(roomCodeProvider.future);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.deleteMemo(
        roomCode: roomCode,
        id: id,
      );
      return readMemo();
    });
  }
}

final memoProvider = AsyncNotifierProvider<AsyncMemos, List<Memo>>(
  AsyncMemos.new,
);
