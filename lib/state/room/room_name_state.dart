import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final roomNameProvider = StateNotifierProvider<RoomNameNotifier, String>((ref) {
  return RoomNameNotifier();
});

class RoomNameNotifier extends StateNotifier<String> {
  RoomNameNotifier() : super('');

  late String roomCode;

  Future<void> fetchRoomName() async {
    roomCode = await getRoomCodeFire(uid);
    state = await getRoomNameFire(roomCode);
  }

  Future<void> changeRoomName(String newRoomName) async {
    changeRoomNameValidation(newRoomName);
    await updateRoomNameFire(roomCode, newRoomName);
    state = newRoomName;
  }

}
