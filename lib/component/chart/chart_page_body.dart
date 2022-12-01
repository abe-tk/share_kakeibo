import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/impoter.dart';

class ChartPageBody extends StatelessWidget {
  final String largeCategory;
  final bool category;
  final List<PieChartSectionData> pieChartSectionData;
  final int totalPrice;
  final int length;
  final List<Map<String, dynamic>> chartSourceData;

  const ChartPageBody({
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
        // 円グラフの表示
        Material(
          elevation: 3,
          child: SizedBox(
            height: 240,
            width: MediaQuery.of(context).size.width,
            child: AppPieChart(
              pieChartSectionData: pieChartSectionData,
              price: totalPrice,
            ),
          ),
        ),
        // 円グラフ内の各値をリスト表示
        const SizedBox(height: 6),
        Expanded(
          child: ListView.builder(
            itemCount: length + 1,
            itemBuilder: (context, index) {
              if (index == length) {
                // リストの最後に合計値を表示
                return Container(
                  alignment: Alignment.centerRight,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(bottom: 30, right: 8),
                  child: Text(
                    '合計 ${formatter.format(totalPrice)} 円',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: CustomColor.detailTextColor,
                    ),
                  ),
                );
              }
              // 各値
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
                              // カテゴリのアイコン
                              ? Icon(
                                chartSourceData[index]['icon'],
                                color: chartSourceData[index]['color'],
                              )
                              // ユーザのプロフィール画像
                              : CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                  chartSourceData[index]['imgURL'],
                                ),
                              ),
                              const SizedBox(width: 10),
                              // カテゴリ名
                              Text(chartSourceData[index]['category']),
                              // パーセント
                              Text(' / ${double.parse((chartSourceData[index]['percent']).toString()).toStringAsFixed(1)}%'),
                            ],
                          ),
                          // 金額
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
