import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/impoter.dart';

class AppPieChart extends ConsumerWidget {
  final String largeCategory;
  final bool category;
  final List<PieChartSectionData> pieChartSectionData;
  final int totalPrice;
  final int length;
  final List<Map<String, dynamic>> chartSourceData;

  const AppPieChart({
    Key? key,
    required this.largeCategory,
    required this.category,
    required this.pieChartSectionData,
    required this.totalPrice,
    required this.length,
    required this.chartSourceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    largeCategory,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: pieChartCenterTextColor,
                    ),
                  ),
                  Text(
                    '${formatter.format(totalPrice)}円',
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
                        sections: pieChartSectionData,
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
            itemCount: length + 1,
            itemBuilder: (context, index) {
              if (index == length) {
                return Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 30, right: 8),
                  child: Text(
                    '合計 ${formatter.format(totalPrice)} 円',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: detailTextColor),
                  ),
                );
              }
              return Visibility(
                visible: chartSourceData[index]['price'] != 0 ? true : false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              category == true
                              ? Icon(
                                chartSourceData[index]['icon'],
                                color: chartSourceData[index]['color'],
                              )
                              : CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  chartSourceData[index]['imgURL'],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(chartSourceData[index]['category']),
                              Text(' / ${double.parse((chartSourceData[index]['percent']).toString()).toStringAsFixed(1)}%'),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            width: MediaQuery.of(context).size.width,
                            child: Text(
                              '${formatter.format(chartSourceData[index]['price'])} 円',
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
