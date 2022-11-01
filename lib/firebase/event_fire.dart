import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/model/event/event.dart';

final fire = FirebaseFirestore.instance.collection('users');

// イベントを追加
Future<void> addEventFire(code, date, price, largeCategory, smallCategory, memo,
    currentMonth, paymentUser) async {
  await fire.doc(code).collection('events').add({
    'date': date,
    'price': price,
    'largeCategory': largeCategory,
    'smallCategory': smallCategory,
    'memo': memo,
    'registerDate': currentMonth,
    'paymentUser': paymentUser,
  });
}

// イベントを削除
Future<void> deleteEventFire(code, id) async {
  await fire.doc(code).collection('events').doc(id).delete();
}

// イベントを編集
Future<void> updateEventFire(code, Event event, date, price, largeCategory,
    smallCategory, memo, currentMonth, paymentUser) async {
  await fire.doc(code).collection('events').doc(event.id).update({
    'date': date,
    'price': price,
    // 'largeCategory': largeCategory,
    'smallCategory': smallCategory,
    'memo': memo,
    'registerDate': currentMonth,
    'paymentUser': paymentUser,
  });
}

// カレンダーのイベントを取得
List<Event> eventList = [];
Map<DateTime, List<Event>> eventMap = {};
Future<Map<DateTime, List<Event>>> setCalendarEventFire(code) async {
  eventMap = {};
  final snapshot = await fire.doc(code).collection('events').get();
  final events = snapshot.docs.map((doc) => Event(
    id: doc.id,
    date: (doc['date'] as Timestamp).toDate(),
    price: doc['price'],
    largeCategory: doc['largeCategory'],
    smallCategory: doc['smallCategory'],
    memo: doc['memo'],
    paymentUser: doc['paymentUser'],
  )).toList();
  eventList = events;
  for (final doc in snapshot.docs) {
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
  return eventMap;
}

// カレンダーのイベントをリストで取得
Future<List<Event>> setEventListFire(code) async {
  eventMap = {};
  final snapshot = await fire.doc(code).collection('events').get();
  final events = snapshot.docs.map((doc) => Event(
    id: doc.id,
    date: (doc['date'] as Timestamp).toDate(),
    price: doc['price'],
    largeCategory: doc['largeCategory'],
    smallCategory: doc['smallCategory'],
    memo: doc['memo'],
    paymentUser: doc['paymentUser'],
  )).toList();
  events.sort((a, b) => b.date.compareTo(a.date));
  return events;
}
