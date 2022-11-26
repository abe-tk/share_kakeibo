import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final roomMemberProvider =
StateNotifierProvider<RoomMemberNotifier, List<RoomMember>>((ref) {
  return RoomMemberNotifier();
});

class RoomMemberNotifier extends StateNotifier<List<RoomMember>> {
  RoomMemberNotifier() : super([]);

  late String roomCode;

  Future<void> fetchRoomMember() async {
    roomCode = await getRoomCodeFire(uid);
    state = await getRoomMemberFire(roomCode);
  }

}
