// state
import 'package:share_kakeibo/state/event/event_state.dart';
// model
import 'package:share_kakeibo/model/event.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final detailEventViewModelProvider =
StateNotifierProvider<DetailEventViewModelNotifier, List<Event>>((ref) {
  return DetailEventViewModelNotifier();
});

class DetailEventViewModelNotifier extends StateNotifier<List<Event>> {
  DetailEventViewModelNotifier() : super([]);

  void fetchDetailEvent() {
    final events = EventNotifier().state.map((doc) => Event(
      id: doc.id,
      date: (doc['date'] as Timestamp).toDate(),
      price: doc['price'],
      largeCategory: doc['largeCategory'],
      smallCategory: doc['smallCategory'],
      memo: doc['memo'],
      paymentUser: doc['paymentUser'],
    )).toList();
    events.sort((a, b) => b.date.compareTo(a.date));
    state = events;
  }

}