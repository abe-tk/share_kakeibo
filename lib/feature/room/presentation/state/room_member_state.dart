import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/room/data/room_member_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

final roomMemberProvider =
    AsyncNotifierProvider<RoomNameState, List<RoomMember>>(RoomNameState.new);

class RoomNameState extends AsyncNotifier<List<RoomMember>> {
  Future<List<RoomMember>> readRoomMember({
    required String roomCode,
  }) async {
    final repository = ref.watch(roomMemberRepositoryProvider);
    return repository.readRoomMember(
      roomCode: roomCode,
    );
  }

  // 初期データの読み込み
  @override
  FutureOr<List<RoomMember>> build() async {
    return await readRoomMember(
        roomCode: await RoomFire().getRoomCodeFire(ref.watch(uidProvider)));
  }

  Future<void> joinRoom({
    required String roomCode,
    required String userName,
    required String imgURL,
  }) async {
    final repository = ref.watch(roomMemberRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.joinRoom(
        roomCode: roomCode,
        uid: ref.watch(uidProvider),
        userName: userName,
        imgURL: imgURL,
      );

      return readRoomMember(roomCode: roomCode);
    });
  }

    Future<void> exitRoom({
    required String roomCode,
    required String userName,
  }) async {
    final repository = ref.watch(roomMemberRepositoryProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.exitRoom(
        roomCode: roomCode,
        uid: ref.watch(uidProvider),
        userName: userName,
      );

      return readRoomMember(roomCode: roomCode);
    });
  }
}
