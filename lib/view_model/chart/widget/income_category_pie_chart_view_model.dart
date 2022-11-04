// model
import 'package:share_kakeibo/model/pie_data/pie_data.dart';
// state
import 'package:share_kakeibo/state/event/event_state.dart';
import 'package:share_kakeibo/state/current_month/chart_current_month_state.dart';
// utility
import 'package:share_kakeibo/utility/price_utility.dart';
import 'package:share_kakeibo/utility/pie_chart_utility.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

final incomeCategoryPieChartViewModelStateProvider =
StateNotifierProvider<IncomeCategoryPieChartViewModelState, List<PieChartSectionData>>((ref) {
  return IncomeCategoryPieChartViewModelState();
});

class IncomeCategoryPieChartViewModelState extends StateNotifier<List<PieChartSectionData>> {
  IncomeCategoryPieChartViewModelState() : super([]);

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
  void incomeCategoryChartCalc() {

    setInitialize();

    // 当月の収入（カテゴリー）の合計金額をセット
    totalPrice = calcCurrentMonthLargeCategoryPrice(EventNotifier().state, ChartCurrentMonthNotifier().state, '収入');

    // 各カテゴリーの金額を算出
    for (int i = 0; i < chartSourceData.length; i++) {
      int price = 0;
      price = calcCategoryPrice(EventNotifier().state, ChartCurrentMonthNotifier().state, '収入', chartSourceData[i]['category']);
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
