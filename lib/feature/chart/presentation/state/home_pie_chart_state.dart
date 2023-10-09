import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/chart/application/pie_chart_service.dart';
import 'package:share_kakeibo/feature/chart/domain/pie_chart_datatable_state.dart';
import 'package:share_kakeibo/feature/chart/domain/pie_chart_source_data.dart';
import 'package:share_kakeibo/importer.dart';

// HomePageの円グラフのプロバイダ
class HomePieChartNotifier extends AutoDisposeNotifier<PieChartDatatableState> {
  PieChartDatatableState calcPieData({
    required DateTime date,
  }) {
    // PieChartServiceのプロバイダ
    final pieChartService = ref.watch(pieChartServiceProvider);

    // イベントを取得
    final events =
        ref.watch(eventProvider).whenOrNull(data: (data) => data) ?? [];

    // 当月の収入の金額を算出
    final plusPrice = pieChartService.calcTotalPrice(
      events: events,
      date: date,
      largeCategory: '収入',
    );

    // 当月の支出の金額を算出
    final minusPrice = pieChartService.calcTotalPrice(
      events: events,
      date: date,
      largeCategory: '支出',
    );

    // 当月の収支金額を算出
    final totalPrice = plusPrice - minusPrice;

    // 当月の収入のパーセントを算出
    final plusPercent = pieChartService.calcBpPercent(
      smallPrice: plusPrice,
      largePrice: plusPrice + minusPrice,
    );

    // 当月の支出のパーセントを算出
    final minusPercent = pieChartService.calcBpPercent(
      smallPrice: minusPrice,
      largePrice: plusPrice + minusPrice,
    );

    // pieChartSourceDataを作成
    final pieChartSourceData = totalPrice == 0
        ? [
            const PieChartSourceData(
              category: 'データなし',
              icon: null,
              imgURL: null,
              color: Color.fromRGBO(130, 132, 130, 1.0),
              price: 0,
              percent: 100,
            ),
          ]
        : pieChartService.setBpData(
            categories: Category.bp,
            prices: [plusPrice, minusPrice],
            percents: [plusPercent, minusPercent],
          );

    return PieChartDatatableState(
      totalPrice: totalPrice,
      pieChartSourceData: pieChartSourceData,
    );
  }

  @override
  PieChartDatatableState build() {
    return calcPieData(
      date: DateTime(DateTime.now().year, DateTime.now().month),
    );
  }

  void reCalc({
    required DateTime date,
  }) {
    state = calcPieData(
      date: date,
    );
  }
}

final homePieChartProvider =
    AutoDisposeNotifierProvider<HomePieChartNotifier, PieChartDatatableState>(
  () => HomePieChartNotifier(),
);
