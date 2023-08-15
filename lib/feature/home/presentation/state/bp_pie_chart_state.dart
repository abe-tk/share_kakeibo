import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/impoter.dart';

final bpPieChartStateProvider = StateNotifierProvider<BpPieChartStateNotifier, List<PieChartSectionData>>((ref) {
  return BpPieChartStateNotifier();
});

class BpPieChartStateNotifier extends StateNotifier<List<PieChartSectionData>> {
  BpPieChartStateNotifier() : super([]);

  late String roomCode;

  int incomePrice = 0;
  int spendingPrice = 0;
  int totalPrice = 0;
  int calcTotalPrice = 0;
  double incomePercent = 0.0;
  double spendingPercent = 0.0;
  double nonDataCase = 0.0;
  List<PieData> pieData = [];

  void setInitialize() {
    incomePrice = 0;
    spendingPrice = 0;
    totalPrice = 0;
    calcTotalPrice = 0;
    incomePercent = 0.0;
    spendingPercent = 0.0;
    nonDataCase = 0.0;
    pieData = [];
  }

  void bpPieChartCalc(DateTime date, List<QueryDocumentSnapshot<Map<String, dynamic>>> event) {

    // イニシャライズ
    setInitialize();

    // 当月の収入、支出、合計の金額を算出
    incomePrice = calcCurrentMonthLargeCategoryPrice(event, date, '収入');
    spendingPrice = calcCurrentMonthLargeCategoryPrice(event, date, '支出');
    calcTotalPrice = incomePrice + spendingPrice;
    totalPrice = incomePrice - spendingPrice;

    // 当月の収入、支出のパーセントを算出
    incomePercent = setPercent(incomePrice, calcTotalPrice);
    spendingPercent = setPercent(spendingPrice, calcTotalPrice);
    nonDataCase = (incomePrice != 0 || spendingPrice != 0) ? 0 : 100;

    // 当月の収支円グラフの値をセット
    pieData = [
      PieData(
          title: '${incomePercent != 0 ? incomePercent.toStringAsFixed(1) : 0}％\n収入',
          percent: incomePercent,
          color: Colors.greenAccent),
      PieData(
          title: '${spendingPercent != 0 ? spendingPercent.toStringAsFixed(1) : 0}％\n支出',
          percent: spendingPercent,
          color: Colors.redAccent),
      PieData(
          title: 'データなし',
          percent: nonDataCase,
          color: const Color.fromRGBO(130, 132, 130, 1.0)),
    ];

    state = getCategory(pieData);
  }

  // アプリ起動直後のみ使用
  Future<void> bpPieChartFirstCalc(DateTime date) async {

    // roomCodeの取得
    roomCode = await RoomFire().getRoomCodeFire(uid);

    // イニシャライズ
    setInitialize();

    // 当月の収入、支出、合計の金額を算出
    incomePrice = await EventFire().firstCalcLargeCategoryPrice(roomCode, date, '収入');
    spendingPrice = await EventFire().firstCalcLargeCategoryPrice(roomCode, date, '支出');

    calcTotalPrice = incomePrice + spendingPrice;
    totalPrice = incomePrice - spendingPrice;

    // 当月の収入、支出のパーセントを算出
    incomePercent = setPercent(incomePrice, calcTotalPrice);
    spendingPercent = setPercent(spendingPrice, calcTotalPrice);
    nonDataCase = (incomePrice != 0 || spendingPrice != 0) ? 0 : 100;

    // 当月の収支円グラフの値をセット
    pieData = [
      PieData(
          title: '${incomePercent != 0 ? incomePercent.toStringAsFixed(1) : 0}％\n収入',
          percent: incomePercent,
          color: Colors.greenAccent),
      PieData(
          title: '${spendingPercent != 0 ? spendingPercent.toStringAsFixed(1) : 0}％\n支出',
          percent: spendingPercent,
          color: Colors.redAccent),
      PieData(
          title: 'データなし',
          percent: nonDataCase,
          color: const Color.fromRGBO(130, 132, 130, 1.0)),
    ];
    state = getCategory(pieData);
  }

}
