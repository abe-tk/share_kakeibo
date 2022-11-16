import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

List<RoomMember> roomMemberList = [];

final roomMemberProvider =
StateNotifierProvider<RoomMemberNotifier, List<RoomMember>>((ref) {
  return RoomMemberNotifier();
});

class RoomMemberNotifier extends StateNotifier<List<RoomMember>> {
  RoomMemberNotifier() : super(roomMemberList);

  late String roomCode;

  Future<void> fetchRoomMember() async {
    roomCode = await setRoomCodeFire(uid);
    roomMemberList = await setRoomMemberFire(roomCode);
    state = roomMemberList;
  }

}
