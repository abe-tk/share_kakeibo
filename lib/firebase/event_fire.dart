import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/model/event.dart';

// イベントを取得
Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getEventFire(String roomCode) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').get();
  return snapshot.docs;
}

// イベントを追加
Future<void> addEventFire(String roomCode, DateTime date, String price, String largeCategory, String smallCategory, String memo, DateTime currentMonth, String paymentUser,) async {
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').add({
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
Future<void> deleteEventFire(String roomCode, String id) async {
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').doc(id).delete();
}

// イベントを編集
Future<void> updateEventFire(String roomCode, Event event, DateTime date, String price, String smallCategory, String memo, DateTime currentMonth, String paymentUser) async {
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').doc(event.id).update({
    'date': date,
    'price': price,
    'smallCategory': smallCategory,
    'memo': memo,
    'registerDate': currentMonth,
    'paymentUser': paymentUser,
  });
}

// アプリ起動直後、Home画面の収支円グラフを正常に表示するために使用
Future<int> firstCalcLargeCategoryPrice(String roomCode, DateTime currentMonth, String largeCategory) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(roomCode)
      .collection('events')
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
Future<int> firstCalcTotalPrice(String roomCode, String largeCategory) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(roomCode)
      .collection('events')
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
