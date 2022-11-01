// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/bar_chart/bar_chart_state.dart';
import 'package:share_kakeibo/state/current_month/bar_chart_year_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class YearChartPage extends StatefulHookConsumerWidget {
  const YearChartPage({Key? key}) : super(key: key);

  @override
  _YearChartPageState createState() => _YearChartPageState();
}

class _YearChartPageState extends ConsumerState<YearChartPage> {

  @override
  void initState() {
    super.initState();
    ref.read(yearChartProvider.notifier).setBarChartData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('支出の推移'),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    ref.read(currentYearProvider.notifier).oneYearAgo();
                    ref.read(yearChartProvider.notifier).setBarChartData();
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    color: detailIconColor,
                  ),
                ),
                const SizedBox(width: 20),
                Text(DateFormat.y('ja').format(ref.watch(currentYearProvider)), style: const TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () {
                    ref.read(currentYearProvider.notifier).oneYearLater();
                    ref.read(yearChartProvider.notifier).setBarChartData();
                  },
                  icon: Icon(
                    Icons.chevron_right,
                    color: detailIconColor,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
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
                        child: const Text('（円）'),
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
                                    BarChartRodData(y: ref.watch(yearChartProvider)[0], width: 10),
                                  ]),
                                  BarChartGroupData(x: 2, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[1], width: 10),
                                  ]),
                                  BarChartGroupData(x: 3, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[2], width: 10),
                                  ]),
                                  BarChartGroupData(x: 4, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[3], width: 10),
                                  ]),
                                  BarChartGroupData(x: 5, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[4], width: 10),
                                  ]),
                                  BarChartGroupData(x: 6, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[5] , width: 10),
                                  ]),
                                  BarChartGroupData(x: 7, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[6], width: 10),
                                  ]),
                                  BarChartGroupData(x: 8, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[7], width: 10),
                                  ]),
                                  BarChartGroupData(x: 9, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[8], width: 10),
                                  ]),
                                  BarChartGroupData(x: 10, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[9], width: 10),
                                  ]),
                                  BarChartGroupData(x: 11, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[10], width: 10),
                                  ]),
                                  BarChartGroupData(x: 12, barRods: [
                                    BarChartRodData(y: ref.watch(yearChartProvider)[11], width: 10),
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
                        child: const Text('（月）'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            // Container(
            //   padding: EdgeInsets.only(right: 16.0),
            //   alignment: Alignment.centerRight,
            //   width: MediaQuery.of(context).size.width,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       // Text('※注釈'),
            //       Text('1K = 1,000'),
            //       Text('1m = 1,000,000'),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
