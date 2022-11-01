// constant
import 'package:share_kakeibo/constant/number_format.dart';
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/pie_chart/spending_category_pie_chart_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingCategoryPieChart extends StatefulHookConsumerWidget {
  const SpendingCategoryPieChart({Key? key}) : super(key: key);

  @override
  _SpendingCategoryPieChartState createState() => _SpendingCategoryPieChartState();
}

class _SpendingCategoryPieChartState extends ConsumerState<SpendingCategoryPieChart> {

  @override
  void initState() {
    super.initState();
    ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc();
  }

  @override
  Widget build(BuildContext context) {
    final spendingCategoryPieChartState = ref.watch(spendingCategoryPieChartStateProvider);
    final spendingCategoryPieChartNotifier = ref.watch(spendingCategoryPieChartStateProvider.notifier);
    return Column(
      children: [
        Container(
          height: 240,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1,
              ),
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '支出',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: pieChartCenterTextColor,
                    ),
                  ),
                  Text(
                    '${formatter.format(spendingCategoryPieChartNotifier.totalPrice)}円',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: pieChartCenterTextColor,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 1,
                        centerSpaceRadius: 50,
                        sections: spendingCategoryPieChartState,
                      ),
                    ),
                  ),
                  // const Divider(color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: spendingCategoryPieChartNotifier.chartSourceData.length + 1,
            itemBuilder: (context, index) {
              if (index == spendingCategoryPieChartNotifier.chartSourceData.length) {
                return Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 30, right: 8),
                  child: Text(
                    '合計 ${formatter.format(spendingCategoryPieChartNotifier.totalPrice)} 円',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: detailTextColor),
                  ),
                );
              }
              return Visibility(
                visible: spendingCategoryPieChartNotifier.chartSourceData[index]['price'] != 0 ? true : false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Icon(
                                spendingCategoryPieChartNotifier.chartSourceData[index]['icon'],
                                color: spendingCategoryPieChartNotifier.chartSourceData[index]['color'],
                              ),
                              const SizedBox(width: 10),
                              Text(spendingCategoryPieChartNotifier.chartSourceData[index]['category']),
                              Text(' / ${double.parse((spendingCategoryPieChartNotifier.chartSourceData[index]['percent']).toString()).toStringAsFixed(1)}%'),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${formatter.format(spendingCategoryPieChartNotifier.chartSourceData[index]['price'])} 円',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
