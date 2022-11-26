import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final roomCodeProvider =
StateNotifierProvider<RoomCodeNotifier, String>((ref) {
  return RoomCodeNotifier();
});

class RoomCodeNotifier extends StateNotifier<String> {
  RoomCodeNotifier() : super('');

  Future<void> fetchRoomCode() async {
    state = await getRoomCodeFire(uid);
  }

}
