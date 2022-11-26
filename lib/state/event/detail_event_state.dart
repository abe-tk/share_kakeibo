import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/impoter.dart';

final detailEventStateProvider =
StateNotifierProvider<DetailEventStateNotifier, List<Event>>((ref) {
  return DetailEventStateNotifier();
});

class DetailEventStateNotifier extends StateNotifier<List<Event>> {
  DetailEventStateNotifier() : super([]);

  void fetchDetailEvent(List<QueryDocumentSnapshot<Map<String, dynamic>>> event) {
    final events = event.map((doc) => Event(
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