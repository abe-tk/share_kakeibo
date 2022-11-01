import 'package:cloud_firestore/cloud_firestore.dart';

final fire = FirebaseFirestore.instance.collection('users');

// 全期間累計の「収入」または「支出」の金額を取得
Future<int> setTotalLageCategoryPriceFire(largeCategory, code) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await fire.doc(code).collection('events').where('largeCategory', isEqualTo: largeCategory).get();
  for (final document in snapshot.docs) {
    final event = document.data();
    final price = event['price'];
    prices.add(int.parse(price));
    int calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}

// 当月の「収入」または「支出」の金額を取得
Future<int> setCurrentMonthLargeCategoryPriceFire(largeCategory, code, currentMonth) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(code)
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

// 当月の「カテゴリー」毎の金額を取得
Future<int> setCategoryPriceFire(code, month, largeCategory, smallCategory) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await fire
      .doc(code)
      .collection('events')
      .where('registerDate', isEqualTo: month)
      .where('largeCategory', isEqualTo: largeCategory)
      .where('smallCategory', isEqualTo: smallCategory)
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

// 当月の「ユーザー」毎の金額を算出
Future<int> setUserPriceFire(code, month, largeCategory, user) async {
  int calcResult = 0;
  List<int> prices = [];
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(code)
      .collection('events')
      .where('registerDate', isEqualTo: month)
      .where('largeCategory', isEqualTo: largeCategory)
      .where('paymentUser', isEqualTo: user)
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
