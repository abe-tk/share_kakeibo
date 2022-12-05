import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final totalAssetsStateProvider =
StateNotifierProvider<TotalAssetsStateNotifier, int>((ref) {
  return TotalAssetsStateNotifier();
});

class TotalAssetsStateNotifier extends StateNotifier<int> {
  TotalAssetsStateNotifier() : super(0);

  late String roomCode;

  void calcTotalAssets(List<QueryDocumentSnapshot<Map<String, dynamic>>> event) {
    int income = calcLageCategoryPrice(event, '収入');
    int spending = calcLageCategoryPrice(event, '支出');
    state = income - spending;
  }

  // アプリ起動直後のみ使用
  Future<void> firstCalcTotalAssets() async {
    roomCode = await getRoomCodeFire(uid);
    int income = await firstCalcTotalPrice(roomCode, '収入');
    int spending = await firstCalcTotalPrice(roomCode, '支出');
    state = income - spending;
  }

}
