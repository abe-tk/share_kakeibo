import 'package:cloud_firestore/cloud_firestore.dart';

// 全期間の「収入」または「支出」の累計金額を計算
int calcLageCategoryPrice(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> events,
    String largeCategory) {
  int calcResult = 0;
  List<int> prices = [];
  var eventList =
      events.where((event) => event['largeCategory'] == largeCategory);
  for (final document in eventList) {
    final event = document.data();
    final price = event['price'];
    prices.add(int.parse(price));
    int calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}

// 当月の「収入」または「支出」の累計金額を計算
int calcCurrentMonthLargeCategoryPrice(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> events,
    DateTime currentMonth,
    String largeCategory,
    ) {
  int calcResult = 0;
  List<int> prices = [];
  var eventList = events
      .where((event) => (event['registerDate'] as Timestamp).toDate() == currentMonth)
      .where((event) => event['largeCategory'] == largeCategory);
  for (final document in eventList) {
    final event = document.data();
    final price = event['price'];
    prices.add(int.parse(price));
    int calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}

// 当月の「カテゴリー」別の累計金額を計算
int calcCategoryPrice(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> events,
    DateTime currentMonth,
    String largeCategory,
    String smallCategory,
    ) {
  int calcResult = 0;
  List<int> prices = [];
  var eventList = events
      .where((event) => (event['registerDate'] as Timestamp).toDate() == currentMonth)
      .where((event) => event['largeCategory'] == largeCategory)
      .where((event) => event['smallCategory'] == smallCategory);
  for (final document in eventList) {
    final event = document.data();
    final price = event['price'];
    prices.add(int.parse(price));
    int calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}

// 当月の「ユーザー」別の累計金額を計算
int setUserPriceFire(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> events,
    DateTime currentMonth,
    String largeCategory,
    String paymentUser,
    ) {
  int calcResult = 0;
  List<int> prices = [];
  var eventList = events
      .where((event) => (event['registerDate'] as Timestamp).toDate() == currentMonth)
      .where((event) => event['largeCategory'] == largeCategory)
      .where((event) => event['paymentUser'] == paymentUser);
  for (final document in eventList) {
    final event = document.data();
    final price = event['price'];
    prices.add(int.parse(price));
    int calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}

// 年間（各月）の支出額を算出
double setYearChartPrice(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> events,
    DateTime currentYear,
    int month,
    ) {
  double calcResult = 0;
  List<double> prices = [];
  var eventList = events
      .where((event) => (event['registerDate'] as Timestamp).toDate() == DateTime(currentYear.year, month))
      .where((event) => event['largeCategory'] == '支出');
  for (final document in eventList) {
    final event = document.data();
    final price = event['price'];
    prices.add(double.parse(price));
    double calcResults = prices.reduce((a, b) => a + b);
    calcResult = calcResults;
  }
  return calcResult;
}