import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/impoter.dart';

final calendarEventStateProvider =
StateNotifierProvider<CalendarEventStateNotifier, Map<DateTime, List<Event>>>((ref) {
  return CalendarEventStateNotifier();
});

class CalendarEventStateNotifier extends StateNotifier<Map<DateTime, List<Event>>> {
  CalendarEventStateNotifier() : super({});

  void fetchCalendarEvent(List<QueryDocumentSnapshot<Map<String, dynamic>>> event) {
    Map<DateTime, List<Event>> eventMap = {};
    for (final doc in event) {
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

}