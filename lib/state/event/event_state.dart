// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/event_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

List<QueryDocumentSnapshot<Map<String, dynamic>>> events = [];

final eventProvider =
StateNotifierProvider<EventNotifier, List<QueryDocumentSnapshot<Map<String, dynamic>>>>((ref) {
  return EventNotifier();
});

class EventNotifier extends StateNotifier<List<QueryDocumentSnapshot<Map<String, dynamic>>>> {
  EventNotifier() : super(events);

  late String roomCode;

  Future<void> setEvent() async {
    roomCode = await setRoomCodeFire(uid);
    events = await getEventFire(roomCode);
    state = events;
  }

}