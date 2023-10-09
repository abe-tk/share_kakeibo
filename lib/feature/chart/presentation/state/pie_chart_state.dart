import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/constant/category.dart';
import 'package:share_kakeibo/feature/chart/application/pie_chart_service.dart';
import 'package:share_kakeibo/feature/chart/domain/pie_chart_datatable_state.dart';
import 'package:share_kakeibo/feature/chart/domain/pie_chart_source_data.dart';
import 'package:share_kakeibo/feature/event/presentation/state/event_state.dart';
import 'package:share_kakeibo/feature/room/presentation/state/room_member_state.dart';

// 円グラフのプロバイダ
class PieChartNotifier extends AutoDisposeNotifier<PieChartDatatableState> {
  // 円グラフのデータを作成
  PieChartDatatableState createPieData({
    required bool isCategory,
    required DateTime date,
    required String largeCategory,
  }) {
    // PieChartServiceのプロバイダ
    final pieChartService = ref.watch(pieChartServiceProvider);

    // イベントを取得
    final events =
        ref.watch(eventProvider).whenOrNull(data: (data) => data) ?? [];

    // ルームメンバーを取得
    final roomMember =
        ref.watch(roomMemberProvider).whenOrNull(data: (data) => data) ?? [];

    // 収入 or 支出の合計金額
    final totalPrice = pieChartService.calcTotalPrice(
      events: events,
      date: date,
      largeCategory: largeCategory,
    );

    // カテゴリー、ユーザーの金額
    final prices = isCategory
        ? pieChartService.calcCategoryPrice(
            events: events,
            categories: largeCategory == '収入' ? Category.plus : Category.minus,
            date: date,
            largeCategory: largeCategory,
          )
        : pieChartService.calcUserPrice(
            events: events,
            roomMember: roomMember,
            date: date,
            largeCategory: largeCategory,
          );

    // カテゴリー、ユーザーのパーセント
    final percents = pieChartService.calcPercent(
      totalPrice: totalPrice,
      prices: prices,
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
        : isCategory
            ? pieChartService.setCategoryData(
                categories: largeCategory == '収入' ? Category.plus : Category.minus,
                prices: prices,
                percents: percents,
              )
            : pieChartService.setUserData(
                roomMember: roomMember,
                prices: prices,
                percents: percents,
              );

    return PieChartDatatableState(
      totalPrice: totalPrice,
      pieChartSourceData: pieChartSourceData,
    );
  }

  @override
  PieChartDatatableState build() {
    return createPieData(
      isCategory: true,
      date: DateTime(DateTime.now().year, DateTime.now().month),
      largeCategory: '収入',
    );
  }

  void reCalc({
    required bool isCategory,
    required DateTime date,
    required String largeCategory,
  }) {
    state = createPieData(
      isCategory: isCategory,
      date: date,
      largeCategory: largeCategory,
    );
  }
}

final pieChartProvider =
    AutoDisposeNotifierProvider<PieChartNotifier, PieChartDatatableState>(
  () => PieChartNotifier(),
);
