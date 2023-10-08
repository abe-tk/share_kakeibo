import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/constant/minus_category.dart';
import 'package:share_kakeibo/constant/plus_category.dart';
import 'package:share_kakeibo/feature/chart/application/pie_chart_service.dart';
import 'package:share_kakeibo/feature/event/presentation/state/event_state.dart';
import 'package:share_kakeibo/feature/room/presentation/state/room_member_state.dart';

// 円グラフのプロバイダ
class PieChartNotifier
    extends AutoDisposeNotifier<Map<int, List<Map<String, dynamic>>>> {
  // 円グラフのデータを作成
  Map<int, List<Map<String, dynamic>>> createPieData(
    bool isCategory,
    DateTime date,
    String largeCategory,
  ) {
    // イベントを取得
    final event =
        ref.watch(eventProvider).whenOrNull(data: (data) => data) ?? [];

    // sourceDataを作成
    List<Map<String, dynamic>> sourceData = [];
    if (isCategory) {
      sourceData = PieChartService().setCategoryData(
        largeCategory == '収入' ? plusCategory : minusCategory,
      );
    }
    if (!isCategory) {
      sourceData = PieChartService().setUserData(
        ref.watch(roomMemberProvider).whenOrNull(data: (data) => data) ?? [],
      );
    }

    // カテゴリの合計金額をセット
    int totalPrice = PieChartService().calcTotalPrice(
      event: event,
      date: date,
      largeCategory: largeCategory,
    );

    // 各カテゴリーの金額を算出
    for (int i = 0; i < sourceData.length; i++) {
      var data = isCategory
          ? event
              .where(
                (data) => data.registerDate == DateTime(date.year, date.month),
              )
              .where((data) => data.largeCategory == largeCategory)
              .where(
                (data) => data.smallCategory == sourceData[i]['category'],
              )
          : event
              .where(
                (data) => data.registerDate == DateTime(date.year, date.month),
              )
              .where((data) => data.largeCategory == largeCategory)
              .where(
                (data) => data.paymentUser == sourceData[i]['category'],
              );
      for (final document in data) {
        final event = document;
        final price = event.price;
        sourceData[i]['price'] += int.parse(price);
      }
    }

    // 各カテゴリーのパーセントを算出
    for (int i = 0; i < sourceData.length; i++) {
      double percent = 0;
      percent = PieChartService().calcPercent(
        sourceData[i]['price'],
        totalPrice,
      );
      sourceData[i]['percent'] = percent;
    }

    return {totalPrice: sourceData};
  }

  @override
  Map<int, List<Map<String, dynamic>>> build() {
    final Map<int, List<Map<String, dynamic>>> data = createPieData(
      true,
      DateTime(DateTime.now().year, DateTime.now().month),
      '収入',
    );
    return {
      data.keys.first: data.values.first,
    };
  }

  void reCalc(bool isCategory, DateTime date, String largeCategory) {
    final Map<int, List<Map<String, dynamic>>> data = createPieData(
      isCategory,
      date,
      largeCategory,
    );
    state = {
      data.keys.first: data.values.first,
    };
  }
}

final pieChartProvider = AutoDisposeNotifierProvider<PieChartNotifier,
    Map<int, List<Map<String, dynamic>>>>(
  () => PieChartNotifier(),
);
