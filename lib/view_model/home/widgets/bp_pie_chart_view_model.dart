// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
import 'package:share_kakeibo/firebase/event_fire.dart';
// model
import 'package:share_kakeibo/model/pie_data/pie_data.dart';
// state
import 'package:share_kakeibo/state/event/event_state.dart';
import 'package:share_kakeibo/state/current_month/home_current_month_state.dart';
// utility
import 'package:share_kakeibo/utility/price_utility.dart';
import 'package:share_kakeibo/utility/pie_chart_utility.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

final bpPieChartViewModelProvider = StateNotifierProvider<BpPieChartViewModelNotifier, List<PieChartSectionData>>((ref) {
  return BpPieChartViewModelNotifier();
});

class BpPieChartViewModelNotifier extends StateNotifier<List<PieChartSectionData>> {
  BpPieChartViewModelNotifier() : super([]);

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

  void bpPieChartCalc() {

    // イニシャライズ
    setInitialize();

    // 当月の収入、支出、合計の金額を算出
    incomePrice = calcCurrentMonthLargeCategoryPrice(EventNotifier().state, HomeCurrentMonthNotifier().state, '収入');
    spendingPrice = calcCurrentMonthLargeCategoryPrice(EventNotifier().state, HomeCurrentMonthNotifier().state, '支出');
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
  Future<void> bpPieChartFirstCalc() async {

    // roomCodeの取得
    roomCode = await setRoomCodeFire(uid);

    // イニシャライズ
    setInitialize();

    // 当月の収入、支出、合計の金額を算出
    incomePrice = await firstCalcLargeCategoryPrice(roomCode, HomeCurrentMonthNotifier().state, '収入');
    spendingPrice = await firstCalcLargeCategoryPrice(roomCode, HomeCurrentMonthNotifier().state, '支出');

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
