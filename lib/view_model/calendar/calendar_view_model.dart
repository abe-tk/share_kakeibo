// state
import 'package:share_kakeibo/state/event/event_state.dart';
// model
import 'package:share_kakeibo/model/event.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final calendarViewModelProvider =
StateNotifierProvider<CalendarViewModelNotifier, Map<DateTime, List<Event>>>((ref) {
  return CalendarViewModelNotifier();
});

class CalendarViewModelNotifier extends StateNotifier<Map<DateTime, List<Event>>> {
  CalendarViewModelNotifier() : super({});

  void fetchCalendarEvent() {
    Map<DateTime, List<Event>> eventMap = {};
    for (final doc in EventNotifier().state) {
      final event = Event(
        id: doc.id,
        date: (doc['date'] as Timestamp).toDate(),
        price: doc['price'],
        largeCategory: doc['largeCategory'],
        smallCategory: doc['smallCategory'],
        memo: doc['memo'],
        paymentUser: doc['paymentUser'],
      );
      final value = eventMap[event.date] ?? [];
      eventMap[event.date] = [event, ...value];
    }
    state = eventMap;
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