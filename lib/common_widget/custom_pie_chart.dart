import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/importer.dart';

class CustomPieChart extends StatelessWidget {
  final String category;
  final List<PieChartSectionData> pieChartSectionData;
  final int price;
  final VoidCallback? onTaped;

  const CustomPieChart({
    Key? key,
    required this.category,
    required this.pieChartSectionData,
    required this.price,
    this.onTaped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: CustomColor.bdColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0,
              ),
            ],
          ),
        ),
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black38,
              ),
              BoxShadow(
                color: CustomColor.bdColor,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0,
              ),
            ],
          ),
        ),
        Column(
          children: <Widget>[
            Expanded(
              child: Stack(children: [
                PieChart(
                  PieChartData(
                    borderData: FlBorderData(show: false),
                    sectionsSpace: 1,
                    centerSpaceRadius: 50,
                    sections: pieChartSectionData,
                  ),
                ),
              ]),
            ),
          ],
        ),
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
              '${price.separator}円',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: CustomColor.pieChartCenterTextColor,
              ),
            ),
          ],
        ),
        InkWell(
          customBorder: const CircleBorder(),
          onTap: onTaped,
          child: Container(
            width: 200,
            height: 200,
            color: Colors.white.withOpacity(0),
          ),
        ),
      ],
    );
  }
}
