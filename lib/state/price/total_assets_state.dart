import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final totalAssetsStateProvider =
StateNotifierProvider<TotalAssetsStateNotifier, int>((ref) {
  return TotalAssetsStateNotifier();
});

class TotalAssetsStateNotifier extends StateNotifier<int> {
  TotalAssetsStateNotifier() : super(0);

  var first = true;

  late String roomCode;

  void calc(List<QueryDocumentSnapshot<Map<String, dynamic>>> event) {
    switch(first) {
      case true:
        firstCalcTotalAssets();
        first = false;
        break;
      case false:
        calcTotalAssets(event);
        break;
      default:
        print('error');
        break;
    }
  }

  void calcTotalAssets(List<QueryDocumentSnapshot<Map<String, dynamic>>> event) {
    int income = calcLageCategoryPrice(event, '収入');
    int spending = calcLageCategoryPrice(event, '支出');
    state = income - spending;
  }

  Future<void> firstCalcTotalAssets() async {
    roomCode = await getRoomCodeFire(uid);
    int income = await firstCalcTotalPrice(roomCode, '収入');
    int spending = await firstCalcTotalPrice(roomCode, '支出');
    state = income - spending;
  }

  void boolChange() {
    first = true;
  }

}
