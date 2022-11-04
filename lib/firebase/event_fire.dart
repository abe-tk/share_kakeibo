import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/model/event/event.dart';

final fire = FirebaseFirestore.instance.collection('users');

// イベントを取得
Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getEventFire(code) async {
  final snapshot = await fire.doc(code).collection('events').get();
  return snapshot.docs;
}

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
