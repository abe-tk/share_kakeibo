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

final spendingCategoryPieChartViewModelStateProvider =
StateNotifierProvider<SpendingCategoryPieChartViewModelState, List<PieChartSectionData>>((ref) {
  return SpendingCategoryPieChartViewModelState();
});

class SpendingCategoryPieChartViewModelState extends StateNotifier<List<PieChartSectionData>> {
  SpendingCategoryPieChartViewModelState() : super([]);

  int totalPrice = 0;
  double nonDataCase = 0.0;
  List<PieData> pieData = [];
  List<Map<String, dynamic>> chartSourceData = [
    {'category': '食費', 'price': 0, 'percent': 0.0, 'icon': Icons.rice_bowl, 'color': Color(0xFFffe4b5)},
    {'category': '外食費', 'price': 0, 'percent': 0.0, 'icon': Icons.restaurant, 'color': Color(0xFFfa8072)},
    {'category': '日用雑貨費', 'price': 0, 'percent': 0.0, 'icon': Icons.shopping_cart, 'color': Color(0xFFdeb887)},
    {'category': '交通・車両費', 'price': 0, 'percent': 0.0, 'icon': Icons.directions_car_outlined, 'color': Color(0xFFb22222)},
    {'category': '住居費', 'price': 0, 'percent': 0.0, 'icon': Icons.house, 'color': Color(0xFFf4a460)},
    {'category': '光熱費(電気)', 'price': 0, 'percent': 0.0, 'icon': Icons.bolt, 'color': Color(0xFFf0e68c)},
    {'category': '光熱費(ガス)', 'price': 0, 'percent': 0.0, 'icon': Icons.local_fire_department, 'color': Color(0xFFdc143c)},
    {'category': '水道費', 'price': 0, 'percent': 0.0, 'icon': Icons.water_drop, 'color': Color(0xFF00bfff)},
    {'category': '通信費', 'price': 0, 'percent': 0.0, 'icon': Icons.speaker_phone, 'color': Color(0xFFff00ff)},
    {'category': 'レジャー費', 'price': 0, 'percent': 0.0, 'icon': Icons.music_note, 'color': Color(0xFF3cb371)},
    {'category': '教育費', 'price': 0, 'percent': 0.0, 'icon': Icons.school, 'color': Color(0xFF9370db)},
    {'category': '医療費', 'price': 0, 'percent': 0.0, 'icon': Icons.local_hospital_outlined, 'color': Color(0xFFff7f50)},
    {'category': 'ファッション費', 'price': 0, 'percent': 0.0, 'icon': Icons.vaccines, 'color': Color(0xFFffc0cb)},
    {'category': '美容費', 'price': 0, 'percent': 0.0, 'icon': Icons.spa, 'color': Color(0xFFee82ee)},
    {'category': '未分類', 'price': 0, 'percent': 0.0, 'icon': Icons.question_mark, 'color': Colors.grey},
  ];

  void setInitialize() {
    totalPrice = 0;
    nonDataCase = 0.0;
    pieData = [];
  }

  // 当月の支出（カテゴリー）算出
  void spendingCategoryChartCalc() {

    setInitialize();

    // 当月の支出（カテゴリー）の合計金額をセット
    totalPrice = calcCurrentMonthLargeCategoryPrice(EventNotifier().state, ChartCurrentMonthNotifier().state, '支出');

    // 各カテゴリーの金額を算出
    for (int i = 0; i < chartSourceData.length; i++) {
      int price = 0;
      price = calcCategoryPrice(EventNotifier().state, ChartCurrentMonthNotifier().state, '支出', chartSourceData[i]['category']);
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