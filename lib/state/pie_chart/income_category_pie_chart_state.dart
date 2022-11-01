// firebase
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/price_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// model
import 'package:share_kakeibo/model/pie_data/pie_data.dart';
// state
import 'package:share_kakeibo/state/current_month/chart_current_month_state.dart';
// utility
import 'package:share_kakeibo/utility/pie_chart_utility.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final incomeCategoryPieChartStateProvider =
StateNotifierProvider<IncomeCategoryPieChartState, List<PieChartSectionData>>((ref) {
  return IncomeCategoryPieChartState();
});

class IncomeCategoryPieChartState extends StateNotifier<List<PieChartSectionData>> {
  IncomeCategoryPieChartState() : super([]);

  late String roomCode;
  int totalPrice = 0;
  double nonDataCase = 0.0;
  List<PieData> pieData = [];
  List<Map<String, dynamic>> chartSourceData = [
    {'category': '給与', 'price': 0, 'percent': 0.0, 'icon': Icons.account_balance_wallet, 'color': Color(0xFFffd700)},
    {'category': '賞与', 'price': 0, 'percent': 0.0, 'icon': Icons.payments, 'color': Color(0xFFff8c00)},
    {'category': '臨時収入', 'price': 0, 'percent': 0.0, 'icon': Icons.currency_yen, 'color': Color(0xFFff6347)},
    {'category': '未分類', 'price': 0, 'percent': 0.0, 'icon': Icons.question_mark, 'color': Colors.grey},
  ];

  void setInitialize() {
    totalPrice = 0;
    nonDataCase = 0.0;
    pieData = [];
  }

  // 当月の収入（カテゴリー）算出
  Future<void> incomeCategoryChartCalc() async {

    setInitialize();
    roomCode = await setRoomCodeFire(uid);

    // 当月の収入（カテゴリー）の合計金額をセット
    totalPrice = await setCurrentMonthLargeCategoryPriceFire('収入', roomCode, ChartCurrentMonthNotifier().state);

    // 各カテゴリーの金額を算出
    for (int i = 0; i < chartSourceData.length; i++) {
      int price = 0;
      price = await setCategoryPriceFire(roomCode, ChartCurrentMonthNotifier().state, '収入', chartSourceData[i]['category']);
      chartSourceData[i]['price'] = price;
    }

    // 各カテゴリーのパーセントを算出
    for (int i = 0; i < chartSourceData.length; i++) {
      double percent = 0;
      percent = setPercent(chartSourceData[i]['price'], totalPrice);
      chartSourceData[i]['percent'] = percent;
    }

    // 円グラフの値をセット
    pieData = setPieData(chartSourceData, totalPrice);

    // stateを更新
    state = getCategory(pieData);
  }

}
