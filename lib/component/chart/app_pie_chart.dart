import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/impoter.dart';

class AppPieChart extends StatelessWidget {
  final String category;
  final List<PieChartSectionData> pieChartSectionData;
  final int price;

  const AppPieChart({
    Key? key,
    required this.category,
    required this.pieChartSectionData,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CustomColor.pieChartCenterTextColor,
              ),
            ),
            Text(
              '${formatter.format(price)}円',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: CustomColor.pieChartCenterTextColor,
              ),
            ),
          ],
        ),
        Column(
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
          ],
        ),
      ],
    );
  }
}
