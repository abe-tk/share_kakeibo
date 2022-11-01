// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/price_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// model
import 'package:share_kakeibo/model/pie_data/pie_data.dart';
// state
import 'package:share_kakeibo/state/current_month/chart_current_month_state.dart';
import 'package:share_kakeibo/state/room/room_member_state.dart';
// utility
import 'package:share_kakeibo/utility/pie_chart_utility.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

final incomeUserPieChartStateProvider =
StateNotifierProvider<IncomeUserPieChartState, List<PieChartSectionData>>((ref) {
  return IncomeUserPieChartState();
});

class IncomeUserPieChartState extends StateNotifier<List<PieChartSectionData>> {
  IncomeUserPieChartState() : super([]);

  late String roomCode;
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
  Future<void> incomeUserChartCalc() async {

    setInitialize();
    roomCode = await setRoomCodeFire(uid);
    setUserColor();
    setChartData();

    // 当月の収入（ユーザー）の合計金額をセット
    totalPrice = await setCurrentMonthLargeCategoryPriceFire('収入', roomCode, ChartCurrentMonthNotifier().state);

    // 各ユーザーの金額を算出
    for (int i = 0; i < chartSourceData.length; i++) {
      int price = 0;
      price = await setUserPriceFire(roomCode, ChartCurrentMonthNotifier().state, '収入', chartSourceData[i]['category']);
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
  void setChartData() {
    for (int i = 0; i < RoomMemberNotifier().state.length; i++) {
      chartSourceData.add(
        {
          'category': RoomMemberNotifier().state[i].userName,
          'price': 0,
          'percent': 0.0,
          'imgURL': RoomMemberNotifier().state[i].imgURL,
          'color': userColor[i],
        }
      );
    }
  }

  // userColorをセット
  void setUserColor() {
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
    if (userColor.length < RoomMemberNotifier().state.length) {
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
