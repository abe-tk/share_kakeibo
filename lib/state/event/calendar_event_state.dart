// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/event_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// model
import 'package:share_kakeibo/model/event/event.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

final calendarEventProvider =
StateNotifierProvider<CalendarEventNotifier, Map<DateTime, List<Event>>>((ref) {
  return CalendarEventNotifier();
});

class CalendarEventNotifier extends StateNotifier<Map<DateTime, List<Event>>> {
  CalendarEventNotifier() : super({});

  late String roomCode;

  Future<void> fetchCalendarEvent() async {
    roomCode = await setRoomCodeFire(uid);
    state = await setCalendarEventFire(roomCode);
  }

  bool checkExistenceEvent(DateTime selectedDate) {
    bool value = true;
    for (final eventDate in state.keys) {
      if (eventDate.toUtc().add(const Duration(hours: 9)) == selectedDate) {
        value = false;
        break;
      }
    }
    return value;
  }

}