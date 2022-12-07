import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/impoter.dart';

final eventProvider =
StateNotifierProvider<EventNotifier, List<QueryDocumentSnapshot<Map<String, dynamic>>>>((ref) {
  return EventNotifier();
});

class EventNotifier extends StateNotifier<List<QueryDocumentSnapshot<Map<String, dynamic>>>> {
  EventNotifier() : super([]);

  late String roomCode;

  Future<void> setEvent() async {
    roomCode = await RoomFire().getRoomCodeFire(uid);
    state = await EventFire().getEventFire(roomCode);
    // state = events;
  }

}