import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/impoter.dart';

final incomeUserPieChartStateProvider =
StateNotifierProvider<IncomeUserPieChartState, List<PieChartSectionData>>((ref) {
  return IncomeUserPieChartState();
});

class IncomeUserPieChartState extends StateNotifier<List<PieChartSectionData>> {
  IncomeUserPieChartState() : super([]);

  int totalPrice = 0;
  double nonDataCase = 0.0;
  List<Color> userColor = [];
  List<PieData> pieData = [];
  List<Map<String, dynamic>> chartSourceData = [];

  void setInitialize() {
    totalPrice = 0;
    nonDataCase = 0.0;
    pieData = [];
    chartSourceData = [];
  }

  // 当月の収入（ユーザー）算出
  void incomeUserChartCalc(DateTime date, List<QueryDocumentSnapshot<Map<String, dynamic>>> event, List<RoomMember> roomMember) {

    setInitialize();
    setUserColor(roomMember);
    setChartData(roomMember);

    // 当月の収入（ユーザー）の合計金額をセット
    totalPrice = calcCurrentMonthLargeCategoryPrice(event, date, '収入');

    // 各ユーザーの金額を算出
    for (int i = 0; i < chartSourceData.length; i++) {
      int price = 0;
      price = setUserPriceFire(event, date, '収入', chartSourceData[i]['category']);
      chartSourceData[i]['price'] = price;
    }

    // 各ユーザーのパーセントを算出
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

  // ルームメンバーの情報をchartDataにセット
  void setChartData(List<RoomMember> roomMember) {
    for (int i = 0; i < roomMember.length; i++) {
      chartSourceData.add(
        {
          'category': roomMember[i].userName,
          'price': 0,
          'percent': 0.0,
          'imgURL': roomMember[i].imgURL,
          'color': userColor[i],
        }
      );
    }
  }

  // userColorをセット
  void setUserColor(List<RoomMember> roomMember) {
    userColor = [
      const Color(0xFFff6347),
      const Color(0xFF6495ed),
      const Color(0xFF66cdaa),
      const Color(0xFFf0e68c),
      const Color(0xFFe9967a),
      const Color(0xFFba55d3),
      const Color(0xFFffe4c4),
      const Color(0xFFdaa520),
    ];
    // ルームメンバーがuserColorより多かったらuserColorを追加
    if (userColor.length < roomMember.length) {
      userColor.addAll([
        const Color(0xFFff6347),
        const Color(0xFF6495ed),
        const Color(0xFF66cdaa),
        const Color(0xFFf0e68c),
        const Color(0xFFe9967a),
        const Color(0xFFba55d3),
        const Color(0xFFffe4c4),
        const Color(0xFFdaa520),
      ]);
    }
  }

}
