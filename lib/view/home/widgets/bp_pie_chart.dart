// constant
import 'package:share_kakeibo/constant/number_format.dart';
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/current_month/home_current_month_state.dart';
import 'package:share_kakeibo/state/pie_chart/bp_pie_chart_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BpPieChart extends StatefulHookConsumerWidget {
  const BpPieChart({Key? key}) : super(key: key);

  @override
  _BpPieChartState createState() => _BpPieChartState();
}

class _BpPieChartState extends ConsumerState<BpPieChart> {

  @override
  void initState() {
    super.initState();
    ref.read(bpPieChartProvider.notifier).bpPieChartCalc();
  }

  @override
  Widget build(BuildContext context) {
    final bpPieChartNotifier = ref.watch(bpPieChartProvider.notifier);
    final bpPieChartState = ref.watch(bpPieChartProvider);
    final homePieChartState = ref.watch(homeCurrentMonthProvider);
    final homePieChartNotifier = ref.watch(homeCurrentMonthProvider.notifier);
    return Column(
      children: [
        // 対象月の表示
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () async {
                await homePieChartNotifier.oneMonthAgo();
                bpPieChartNotifier.bpPieChartCalc();
              },
              icon: Icon(
                Icons.chevron_left,
                color: detailIconColor,
              ),
            ),
            TextButton(
              child: Text(
                '${DateFormat.yMMM('ja').format(homePieChartState)}の家計簿',
                style: TextStyle(
                  color: normalTextColor,
                ),
              ),
              onPressed: () async {
                await homePieChartNotifier.selectMonth(context);
                bpPieChartNotifier.bpPieChartCalc();
              },
            ),
            IconButton(
              onPressed: () async {
                await homePieChartNotifier.oneMonthLater();
                bpPieChartNotifier.bpPieChartCalc();
              },
              icon: Icon(
                Icons.chevron_right,
                color: detailIconColor,
              ),
            ),
          ],
        ),
        // 円グラフの表示
        Container(
          margin: const EdgeInsets.only(top: 24, bottom: 24),
          height: 160,
          width: 160,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '収支',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: pieChartCenterTextColor,
                    ),
                  ),
                  Text(
                    '${formatter.format(bpPieChartNotifier.totalPrice)}円',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: pieChartCenterTextColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 1,
                          centerSpaceRadius: 50,
                          sections: bpPieChartState,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // 支出・収入・合計の表示
        Padding(
          padding: const EdgeInsets.only(
              left: 24, top: 24, right: 24, bottom: 8),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Row(
                        children: [
                          Text(
                            '支出',
                            style: TextStyle(
                                color: detailTextColor,),
                          ),
                          Text(
                            ' / ${double.parse((bpPieChartNotifier.spendingPercent).toString()).toStringAsFixed(1)}%',
                            style: TextStyle(
                                color: detailTextColor,),
                          )
                        ],
                      )),
                  Container(
                    alignment: Alignment.centerRight,
                    width:
                    MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      '${formatter.format(bpPieChartNotifier.spendingPrice)} 円',
                      style: TextStyle(
                          fontSize: 20,
                          color: spendingTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Stack(
                children: [
                  Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width *
                          0.9,
                      child: Row(
                        children: [
                          Text(
                            '収入',
                            style: TextStyle(
                                color: detailTextColor,),
                          ),
                          Text(
                            ' / ${double.parse((bpPieChartNotifier.incomePercent).toString()).toStringAsFixed(1)}%',
                            style: TextStyle(
                                color: detailTextColor,),
                          )
                        ],
                      )),
                  Container(
                    alignment: Alignment.centerRight,
                    width:
                    MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      '${formatter.format(bpPieChartNotifier.incomePrice)} 円',
                      style: TextStyle(
                          fontSize: 20,
                          color: incomeTextColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const Divider(),
              Stack(
                children: [
                  Container(
                    alignment: Alignment.centerRight,
                    width:
                    MediaQuery.of(context).size.width * 0.9,
                    child: Text(
                      '合計 ${formatter.format(bpPieChartNotifier.totalPrice)} 円',
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
