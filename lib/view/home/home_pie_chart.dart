/// component
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/components/number_format.dart';

/// view
import 'package:share_kakeibo/view_model/home/home_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePieChart extends HookConsumerWidget {
  HomePieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.watch(homeViewModelProvider);

    return Container(
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
                '収支',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(65, 65, 65, 0.8),
                ),
              ),
              Text(
                '${formatter.format(homeViewModel.incomePrice)}円',
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
                      sections: homeViewModel.getCategory(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
