import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/event/data/event_repository.dart';
import 'package:share_kakeibo/importer.dart';

final eventRepositoryProvider = Provider(
  (ref) => EventRepositoryImpl(),
);

class EventRepositoryImpl extends EventRepository {
  // 利用する外部サービスの指定
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Event>> readEvent({
    required String roomCode,
  }) async {
    try {
      // 初期状態は降順
      // final collection =
      //     _firestore.collection('users').doc(roomCode).collection('events');
      // return collection.snapshots().map((snapshot) {
      //   return snapshot.docs.map((doc) {
      //     final data = doc.data();
      //     data['id'] = doc.id;
      //     return Event.fromJson(data);
      //   }).toList();
      // });
      final eventList = <Event>[];
      // 初期状態は降順
      final collection =
          _firestore.collection('users').doc(roomCode).collection('events');
      await collection.get().then(
        (querySnapshot) {
          for (final doc in querySnapshot.docs) {
            final data = doc.data();
            data['id'] = doc.id;
            final event = Event.fromJson(data);
            eventList.add(event);
          }
        },
      );
      return eventList;
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> createEvent({
    required String roomCode,
    required DateTime date,
    required String price,
    required String largeCategory,
    required String smallCategory,
    required String memo,
    required DateTime currentMonth,
    required String paymentUser,
  }) async {
    try {
      addEventValidation(price);
      await _firestore
          .collection('users')
          .doc(roomCode)
          .collection('events')
          .add({
        'date': date,
        'price': price,
        'largeCategory': largeCategory,
        'smallCategory': smallCategory,
        'memo': memo,
        'registerDate': currentMonth,
        'paymentUser': paymentUser,
      });
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteEvent({
    required String roomCode,
    required String id,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(roomCode)
          .collection('events')
          .doc(id)
          .delete();
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> updateEvent({
    required String roomCode,
    required Event event,
    required DateTime date,
    required String price,
    required String smallCategory,
    required String memo,
    required DateTime currentMonth,
    required String paymentUser,
  }) async {
    try {
      addEventValidation(price);
      await _firestore
          .collection('users')
          .doc(roomCode)
          .collection('events')
          .doc(event.id)
          .update({
        'date': date,
        'price': price,
        'smallCategory': smallCategory,
        'memo': memo,
        'registerDate': currentMonth,
        'paymentUser': paymentUser,
      });
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
