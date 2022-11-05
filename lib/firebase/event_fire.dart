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

// アプリ起動直後、Home画面の収支円グラフを正常に表示するために使用
Future<int> firstCalcLargeCategoryPrice(String code, DateTime currentMonth, String largeCategory) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(code).collection('events')
      .where('registerDate', isEqualTo: currentMonth)
      .where('largeCategory', isEqualTo: largeCategory)
      .get();
  for (final document in snapshot.docs) {
    final event = document.data();
    final price = event['price'];
    prices.add(int.parse(price));
    int calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}

// アプリ起動直後、Home画面の累計金額を正常に表示するために使用
Future<int> firstCalcLageCategoryPrice(String code, String largeCategory) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(code).collection('events')
      .where('largeCategory', isEqualTo: largeCategory)
      .get();
  for (final document in snapshot.docs) {
    final event = document.data();
    final price = event['price'];
    prices.add(int.parse(price));
    int calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}