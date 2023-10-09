import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/chart/application/pie_chart_service.dart';
import 'package:share_kakeibo/importer.dart';

final totalAssetsStateProvider =
    StateNotifierProvider<TotalAssetsStateNotifier, int>((ref) {
  return TotalAssetsStateNotifier();
});

class TotalAssetsStateNotifier extends StateNotifier<int> {
  TotalAssetsStateNotifier() : super(0);

  late String roomCode;

  void calcTotalAssets(List<Event> event) {
    int income = PieChartService().calcLargeCategoryPrice(event, '収入');
    int spending = PieChartService().calcLargeCategoryPrice(event, '支出');
    state = income - spending;
  }

  // アプリ起動直後のみ使用
  Future<void> firstCalcTotalAssets(String uid) async {
    roomCode = await RoomFire().getRoomCodeFire(uid);
    int income = await firstCalcTotalPrice(roomCode, '収入');
    int spending = await firstCalcTotalPrice(roomCode, '支出');
    state = income - spending;
  }

  // アプリ起動直後、Home画面の累計金額を正常に表示するために使用
  Future<int> firstCalcTotalPrice(String roomCode, String largeCategory) async {
    int calcResult = 0;
    List<int> prices = [];
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('events')
        .where('largeCategory', isEqualTo: largeCategory)
        .get();
    for (final document in snapshot.docs) {
      final event = document.data();
      final price = event['price'];
      prices.add(int.parse(price));
      int calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }
}
