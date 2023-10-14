import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/room/data/room_name_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

final roomNameProvider = AsyncNotifierProvider<RoomName, String>(RoomName.new);

class RoomName extends AsyncNotifier<String> {
  // ユーザー情報の取得
  Future<String> readRoomName({
    required String roomCode,
  }) async {
    final repository = ref.watch(roomNameRepositoryProvider);
    return repository.readRoomName(
      roomCode: roomCode,
    );
  }

  // 初期データの読み込み
  @override
  FutureOr<String> build() async {
    final roomCode = await ref.watch(roomCodeProvider.future);
    return await readRoomName(roomCode: roomCode);
  }

  // ルーム名の更新
  Future<void> updateRoomName({
    required String roomCode,
    required String newRoomName,
  }) async {
    final repository = ref.watch(roomNameRepositoryProvider);

    // Stateに[AsyncLoading()]を代入し非同期処理が開始
    state = const AsyncLoading();

    // その後、処理の結果が[AsyncData()]もしくは[AsyncError()]としてStateに代入される
    state = await AsyncValue.guard(() async {
      await repository.updateRoomName(
        roomCode: roomCode,
        newRoomName: newRoomName,
      );

      // ルーム名の取得更新
      return readRoomName(roomCode: roomCode);
    });
  }
}
