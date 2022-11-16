import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final roomInfoViewModelProvider =
StateNotifierProvider<RoomInfoViewModelNotifier, Map<String, dynamic>>((ref) {
  return RoomInfoViewModelNotifier();
});

class RoomInfoViewModelNotifier extends StateNotifier<Map<String, dynamic>> {
  RoomInfoViewModelNotifier() : super({});

  String? roomCode;

  Future<void> fetchRoomInfo() async {
    roomCode = await setRoomCodeFire(uid);
  }

  void judgeOwner() {
    if (uid == roomCode) {
      throw 'RoomOwnerは退出できません';
    }
  }

  Future <void> exitRoom() async {
    await exitRoomFire(roomCode, UserNotifier().state['userName']);
  }

}

