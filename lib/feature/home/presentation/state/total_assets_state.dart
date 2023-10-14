import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class TotalAssets extends Notifier<int> {
  // 全期間の「収入」または「支出」の累計金額を計算
  int calcLargeCategoryPrice(
    List<Event> events,
    String largeCategory,
  ) {
    int calcResult = 0;
    List<int> prices = [];
    var eventList =
        events.where((event) => event.largeCategory == largeCategory);
    for (final document in eventList) {
      final event = document;
      final price = event.price;
      prices.add(int.parse(price));
      int calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }

  @override
  int build() {
    final events =
        ref.watch(eventProvider).whenOrNull(data: (data) => data) ?? [];
    int income = calcLargeCategoryPrice(events, '収入');
    int spending = calcLargeCategoryPrice(events, '支出');
    return income - spending;
  }
}

final totalAssetsProvider = NotifierProvider<TotalAssets, int>(
  () => TotalAssets(),
);
