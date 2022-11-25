import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_kakeibo/model/pie_data.dart';

// パーセントの算出
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

// 円グラフの値をセット
List<PieData> setPieData(chartData, price) {
  List<PieData> pieData = [];
  for (int i = 0; i < chartData.length; i++) {
    pieData.add(
      PieData(
          title: '${chartData[i]['percent'] != 0 ? chartData[i]['percent']!.toStringAsFixed(1) : 0}％\n${chartData[i]['category']}',
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
      color: Colors.black54,
    ),
  );
  return MapEntry(index, value);
})
    .values
    .toList();