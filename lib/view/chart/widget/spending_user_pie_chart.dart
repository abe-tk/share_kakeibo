// constant
import 'package:share_kakeibo/constant/number_format.dart';
import 'package:share_kakeibo/constant/colors.dart';
// view_model
import 'package:share_kakeibo/view_model/chart/widget/spending_user_pie_chart_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingUserPieChart extends StatefulHookConsumerWidget {
  const SpendingUserPieChart({Key? key}) : super(key: key);

  @override
  _SpendingUserPieChartState createState() => _SpendingUserPieChartState();
}

class _SpendingUserPieChartState extends ConsumerState<SpendingUserPieChart> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // エラーの出ていた処理
      ref.read(spendingUserPieChartViewModelStateProvider.notifier).spendingUserChartCalc();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spendingUserPieChartState = ref.watch(spendingUserPieChartViewModelStateProvider);
    final spendingUserPieChartNotifier = ref.watch(spendingUserPieChartViewModelStateProvider.notifier);
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
                    '${formatter.format(spendingUserPieChartNotifier.totalPrice)}円',
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
                        sections: spendingUserPieChartState,
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
            itemCount: spendingUserPieChartNotifier.chartSourceData.length + 1,
            itemBuilder: (context, index) {
              if (index == spendingUserPieChartNotifier.chartSourceData.length) {
                return Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 30, right: 8),
                  child: Text(
                    '合計 ${formatter.format(spendingUserPieChartNotifier.totalPrice)} 円',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: detailTextColor),
                  ),
                );
              }
              return Visibility(
                visible: spendingUserPieChartNotifier.chartSourceData[index]['price'] != 0
                    ? true
                    : false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  spendingUserPieChartNotifier.chartSourceData[index]['imgURL'],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(spendingUserPieChartNotifier.chartSourceData[index]['category']),
                              Text(' / ${double.parse((spendingUserPieChartNotifier.chartSourceData[index]['percent']).toString()).toStringAsFixed(1)}%',
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${formatter.format(spendingUserPieChartNotifier.chartSourceData[index]['price'])} 円',
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
