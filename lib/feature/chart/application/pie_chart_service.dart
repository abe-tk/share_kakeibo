import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:share_kakeibo/constant/user_color.dart';
import 'package:share_kakeibo/importer.dart';

final pieChartService = PieChartService();

class PieChartService {
  // カテゴリーの円グラフデータを作成
  List<Map<String, dynamic>> setCategoryData(
    List<Map<String, Object>> categoryData,
  ) {
    List<Map<String, dynamic>> data = [];
    for (int i = 0; i < categoryData.length; i++) {
      data.add({
        'category': categoryData[i]['category'],
        'icon': categoryData[i]['icon'],
        'color': categoryData[i]['color'],
        'price': 0,
        'percent': 0.0,
      });
    }
    return data;
  }

  // ユーザーの円グラフデータを作成
  List<Map<String, Object>> setUserData(
    List<RoomMember> roomMember,
  ) {
    List<Map<String, Object>> data = [];
    for (int i = 0; i < roomMember.length; i++) {
      data.add({
        'category': roomMember[i].userName,
        'imgURL': roomMember[i].imgURL,
        'color': userColor[i],
        'price': 0,
        'percent': 0.0,
      });
    }
    return data;
  }

  // 対象月の収支合計金額を算出
  int calcTotalPrice({
    required List<Event> event,
    required DateTime date,
    required String largeCategory,
  }) {
    List<int> prices = [];
    var eventList = event
        .where(
          (event) => event.registerDate == DateTime(date.year, date.month),
        )
        .where(
          (event) => event.largeCategory == largeCategory,
        );
    for (final document in eventList) {
      final event = document;
      final price = event.price;
      prices.add(int.parse(price));
    }
    return prices.reduce((a, b) => a + b);
  }

  // パーセントの算出
  double calcPercent(int smallPrice, int largePrice) {
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

  double setPercent(int smallPrice, int largePrice) {
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

// 全期間の「収入」または「支出」の累計金額を計算
  int calcLageCategoryPrice(List<Event> events, String largeCategory) {
    int calcResult = 0;
    List<int> prices = [];
    var eventList =
        events.where((event) => event.largeCategory == largeCategory);
    for (final document in eventList) {
      final event = document;
      final price = event.price;
      prices.add(int.parse(price));
      int calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }

// 当月の「収入」または「支出」の累計金額を計算
  int calcCurrentMonthLargeCategoryPrice(
    List<Event> events,
    DateTime currentMonth,
    String largeCategory,
  ) {
    int calcResult = 0;
    List<int> prices = [];
    var eventList = events
        .where((event) => event.registerDate == currentMonth)
        .where((event) => event.largeCategory == largeCategory);
    for (final document in eventList) {
      final event = document;
      final price = event.price;
      prices.add(int.parse(price));
      int calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }

  // 円グラフの値をセット
  List<PieData> setPieData(List<Map<String, dynamic>> chartData, int price) {
    List<PieData> pieData = [];
    for (int i = 0; i < chartData.length; i++) {
      pieData.add(
        PieData(
            title:
                '${chartData[i]['percent'] != 0 ? chartData[i]['percent']!.toStringAsFixed(1) : 0}％\n${chartData[i]['category']}',
            percent: chartData[i]['percent'],
            color: chartData[i]['color']),
      );
    }
    if (price == 0) {
      pieData.add(
        const PieData(
          title: 'データなし',
          percent: 100,
          color: Color.fromRGBO(130, 132, 130, 1.0),
        ),
      );
    }
    return pieData;
  }

// List<PieChartSectionData>型の値をセット
  List<PieChartSectionData> getCategory(List<PieData> pieData) => pieData
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        // const double fontSize = 12;
        // const double radius = 50.w;

        var value = PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: data.title,
          radius: 50,
          titleStyle: const TextStyle(
            // fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: CustomColor.pieChartCategoryTextColor,
          ),
        );
        return MapEntry(index, value);
      })
      .values
      .toList();
}
