// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/event_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// model
import 'package:share_kakeibo/model/event/event.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

final detailEventProvider =
StateNotifierProvider<DetailEventNotifier, List<Event>>((ref) {
  return DetailEventNotifier();
});

class DetailEventNotifier extends StateNotifier<List<Event>> {
  DetailEventNotifier() : super([]);

  late String roomCode;

  Future<void> fetchEventListEvent() async {
    roomCode = await setRoomCodeFire(uid);
    state = await setEventListFire(roomCode);
  }

}