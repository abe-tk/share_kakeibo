/// components
import 'package:share_kakeibo/components/number_format.dart';

/// view_model
import 'package:share_kakeibo/view_model/chart/chart_view_model.dart';

/// packages
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class IncomeChart extends HookConsumerWidget {
  IncomeChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartViewModel = ref.watch(chartViewModelProvider);

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                  height: 200,
                  width: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 74,
                          ),
                          const Text(
                            '収入',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(65, 65, 65, 0.8),
                            ),
                          ),
                          Text(
                            '${formatter.format(chartViewModel.incomePrice)}円',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(65, 65, 65, 0.8),
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
                                  sections: ref
                                      .read(chartViewModelProvider)
                                      .getIncomeCategory(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                (chartViewModel.categoryDisplay == true)
                    ? ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chartViewModel.incomeChartData.length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: (chartViewModel.incomeChartData[index].price != 0) ? true : false,
                      child: Column(
                        children: [
                          ListTile(
                            title:
                            Text(chartViewModel.incomeChartData[index].category!),
                            trailing: Text(
                                '${formatter.format(chartViewModel.incomeChartData[index].price)} 円'),
                            leading: Icon(
                              chartViewModel.incomeChartData[index].icon,
                              color: chartViewModel.incomeChartData[index].color,
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                )
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: chartViewModel.incomeUserChartData.length,
                  itemBuilder: (context, index) {
                    return Visibility(
                      visible: (chartViewModel.incomeUserChartData[index].price != 0) ? true : false,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                                chartViewModel.incomeUserChartData[index].category!),
                            trailing: Text(
                                '${formatter.format(chartViewModel.incomeUserChartData[index].price)} 円'),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chartViewModel.incomeUserChartData[index].imgURL ?? '',
                              ),
                            ),
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                ),
                ListTile(
                  trailing:
                  Text('合計 ${formatter.format(chartViewModel.incomePrice)} 円', style: const TextStyle(fontWeight: FontWeight.bold),),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

