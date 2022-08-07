/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// model
import 'package:share_kakeibo/model/chart_data.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

final homeViewModelProvider = ChangeNotifierProvider((ref) => HomeViewModel());

class HomeViewModel extends ChangeNotifier {

  DateTime nowMonth = DateTime(DateTime.now().year, DateTime.now().month);

  late String roomCode;

  int totalAssets = 0;
  int assetsIncomePrice = 0;
  int assetsSpendingPrice = 0;

  int incomePrice = 0;
  int spendingPrice = 0;
  int totalPrice = 0;
  int calcTotalPrice = 0;
  double incomePercent = 0.0;
  double spendingPercent = 0.0;
  double nonDataCase = 0.0;
  List<PieData> pieData = [];

  /// date
  Future<void> oneMonthAgo() async {
    nowMonth = DateTime(nowMonth.year, nowMonth.month - 1);
    notifyListeners();
  }

  Future<void> oneMonthLater() async {
    nowMonth = DateTime(nowMonth.year, nowMonth.month + 1);
    notifyListeners();
  }

  Future<void> selectMonth(BuildContext context) async {
    var selectedMonth = await showMonthPicker(
      context: context,
      initialDate: nowMonth,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selectedMonth == null) {
      return;
    } else {
      nowMonth = selectedMonth;
    }
    notifyListeners();
  }

  void setInitialize() {
    totalAssets = 0;
    assetsIncomePrice = 0;
    assetsSpendingPrice = 0;

    incomePrice = 0;
    spendingPrice = 0;
    totalPrice = 0;
    calcTotalPrice = 0;
    incomePercent = 0.0;
    spendingPercent = 0.0;
    nonDataCase = 0.0;
    pieData = [];
  }

  Future setAssetsPrice(largeCategory) async {
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

  Future setPrice(largeCategory) async {
    int calcResult = 0;
    List<int> prices = [];
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('events')
        .where('registerDate', isEqualTo: nowMonth)
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

  double setPercent(smallPrice, largePrice) {
    double calcResult = 0;
    double percent = 0;
    if (smallPrice != 0) {
      percent = smallPrice / largePrice * 100;
    } else {
      percent = 0;
    }
    calcResult = percent;
    return calcResult;
  }

  /// 総資産額
  Future <void> assetsCalc() async {

    setInitialize();

    final codeSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = codeSnapshot.data();
    roomCode = data?['roomCode'];

    assetsIncomePrice = await setAssetsPrice('収入');
    assetsSpendingPrice = await setAssetsPrice('支出');
    totalAssets = assetsIncomePrice - assetsSpendingPrice;

    calc();

    notifyListeners();
  }

  /// 当月の金額
  Future <void> calc() async {
    // price
    incomePrice = await setPrice('収入');
    spendingPrice = await setPrice('支出');
    calcTotalPrice = incomePrice + spendingPrice;
    totalPrice = incomePrice - spendingPrice;

    // percent
    incomePercent = setPercent(incomePrice, calcTotalPrice);
    spendingPercent = setPercent(spendingPrice, calcTotalPrice);
    nonDataCase = (incomePrice != 0 || spendingPrice != 0) ? 0 : 100;

    pieData = [
      PieData(
          title: '収入\n${incomePercent != 0 ? incomePercent.round() : 0} ％',
          percent: incomePercent,
          color: Colors.greenAccent),
      PieData(
          title: '支出\n${spendingPercent != 0 ? spendingPercent.round() : 0} ％',
          percent: spendingPercent,
          color: Colors.redAccent),
      PieData(
          title: 'データなし',
          percent: nonDataCase,
          color: const Color.fromRGBO(130, 132, 130, 1.0)),
    ];
    notifyListeners();
  }

  List<PieChartSectionData> getCategory() => pieData
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        const double fontSize = 16;
        const double radius = 50;

        var value = PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: data.title,
          radius: radius,
          titleStyle: const TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        );
        return MapEntry(index, value);
      })
      .values
      .toList();
}
