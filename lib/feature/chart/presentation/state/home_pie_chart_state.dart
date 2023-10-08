import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_kakeibo/feature/chart/application/pie_chart_service.dart';
import 'package:share_kakeibo/importer.dart';

class HomePieChartNotifier
    extends AutoDisposeNotifier<Map<int, List<PieChartSectionData>>> {
  Map<int, List<PieData>> calcPieData(DateTime date) {
    // 当月の収入、支出、合計の金額を算出
    final incomePrice = PieChartService().calcCurrentMonthLargeCategoryPrice(
      ref.watch(eventProvider).whenOrNull(data: (data) => data) ?? [],
      date,
      '収入',
    );
    final spendingPrice = PieChartService().calcCurrentMonthLargeCategoryPrice(
      ref.watch(eventProvider).whenOrNull(data: (data) => data) ?? [],
      date,
      '支出',
    );
    final calcTotalPrice = incomePrice + spendingPrice;
    final totalPrice = incomePrice - spendingPrice;

    // 当月の収入、支出のパーセントを算出
    final incomePercent = PieChartService().setPercent(incomePrice, calcTotalPrice);
    final spendingPercent = PieChartService().setPercent(spendingPrice, calcTotalPrice);
    final double nonDataCase =
        (incomePrice != 0 || spendingPrice != 0) ? 0 : 100;

    return {
      totalPrice: [
        PieData(
            title:
                '${incomePercent != 0 ? incomePercent.toStringAsFixed(1) : 0}％\n収入',
            percent: incomePercent,
            color: Colors.greenAccent),
        PieData(
            title:
                '${spendingPercent != 0 ? spendingPercent.toStringAsFixed(1) : 0}％\n支出',
            percent: spendingPercent,
            color: Colors.redAccent),
        PieData(
          title: 'データなし',
          percent: nonDataCase,
          color: const Color.fromRGBO(130, 132, 130, 1.0),
        ),
      ],
    };
  }

  @override
  Map<int, List<PieChartSectionData>> build() {
    final Map<int, List<PieData>> data = calcPieData(
      DateTime(DateTime.now().year, DateTime.now().month),
    );
    return {
      data.keys.first: PieChartService().getCategory(data.values.first),
    };
  }

  void reCalc(DateTime date) {
    final Map<int, List<PieData>> data = calcPieData(date);
    state = {
      data.keys.first: PieChartService().getCategory(data.values.first),
    };
  }
}

final homePieChartProvider =
    AutoDisposeNotifierProvider<HomePieChartNotifier, Map<int, List<PieChartSectionData>>>(
  () => HomePieChartNotifier(),
);
