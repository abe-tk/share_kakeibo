import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class CalendarEventNotifier extends Notifier<Map<DateTime, List<Event>>> {
  @override
  Map<DateTime, List<Event>> build() {
    Map<DateTime, List<Event>> eventMap = {};
    final event =
        ref.watch(eventProvider).whenOrNull(data: (data) => data) ?? [];
    for (final doc in event) {
      final event = Event(
        id: doc.id,
        date: doc.date,
        registerDate: doc.registerDate,
        price: doc.price,
        largeCategory: doc.largeCategory,
        smallCategory: doc.smallCategory,
        memo: doc.memo,
        paymentUser: doc.paymentUser,
      );
      final value = eventMap[event.date] ?? [];
      eventMap[event.date] = [event, ...value];
    }
    return eventMap;
  }
}

final calendarEventProvider =
    NotifierProvider<CalendarEventNotifier, Map<DateTime, List<Event>>>(
  () => CalendarEventNotifier(),
);
