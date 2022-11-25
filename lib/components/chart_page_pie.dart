import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/impoter.dart';

class ChartPagePie extends StatelessWidget {
  final String largeCategory;
  final bool category;
  final List<PieChartSectionData> pieChartSectionData;
  final int totalPrice;
  final int length;
  final List<Map<String, dynamic>> chartSourceData;

  const ChartPagePie({
    Key? key,
    required this.largeCategory,
    required this.category,
    required this.pieChartSectionData,
    required this.totalPrice,
    required this.length,
    required this.chartSourceData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          child: AppPieChart(
            pieChartSectionData: pieChartSectionData,
            price: totalPrice,
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
