import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/impoter.dart';

class AppBarChart extends StatelessWidget {
  final List<double> price;
  final String verticalAxisValue;
  final String horizontalAxisValue;

  const AppBarChart({
    Key? key,
    required this.price,
    required this.verticalAxisValue,
    required this.horizontalAxisValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: boxShadowColor,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.only(left: 16.0),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text('（$verticalAxisValue）'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BarChart(
                  BarChartData(
                      gridData: FlGridData(
                        show: true,
                        checkToShowVerticalLine: (value) => value % 5 == 0,
                      ),
                      titlesData: FlTitlesData(
                        topTitles: SideTitles(
                          showTitles: false,
                        ),
                        rightTitles: SideTitles(
                          showTitles: false,
                        ),
                      ),
                      borderData: FlBorderData(
                          border: const Border(
                            bottom: BorderSide(width: 0.3),
                          )),
                      groupsSpace: 10,
                      barGroups: [
                        BarChartGroupData(x: 1, barRods: [
                          BarChartRodData(y: price[0], width: 10),
                        ]),
                        BarChartGroupData(x: 2, barRods: [
                          BarChartRodData(y: price[1], width: 10),
                        ]),
                        BarChartGroupData(x: 3, barRods: [
                          BarChartRodData(y: price[2], width: 10),
                        ]),
                        BarChartGroupData(x: 4, barRods: [
                          BarChartRodData(y: price[3], width: 10),
                        ]),
                        BarChartGroupData(x: 5, barRods: [
                          BarChartRodData(y: price[4], width: 10),
                        ]),
                        BarChartGroupData(x: 6, barRods: [
                          BarChartRodData(y: price[5], width: 10),
                        ]),
                        BarChartGroupData(x: 7, barRods: [
                          BarChartRodData(y: price[6], width: 10),
                        ]),
                        BarChartGroupData(x: 8, barRods: [
                          BarChartRodData(y: price[7], width: 10),
                        ]),
                        BarChartGroupData(x: 9, barRods: [
                          BarChartRodData(y: price[8], width: 10),
                        ]),
                        BarChartGroupData(x: 10, barRods: [
                          BarChartRodData(y: price[9], width: 10),
                        ]),
                        BarChartGroupData(x: 11, barRods: [
                          BarChartRodData(y: price[10], width: 10),
                        ]),
                        BarChartGroupData(x: 12, barRods: [
                          BarChartRodData(y: price[11], width: 10),
                        ]),
                      ]),
                  swapAnimationDuration: const Duration(milliseconds: 150),
                  swapAnimationCurve: Curves.linear,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 16.0),
              alignment: Alignment.centerRight,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text('（$horizontalAxisValue）'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
