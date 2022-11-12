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

  void calc() {
    switch(first) {
      case true:
        firstCalcTotalAssets();
        first = false;
        break;
      case false:
        calcTotalAssets();
        break;
      default:
        print('error');
        break;
    }
  }

  void calcTotalAssets() {
    int income = calcLageCategoryPrice(EventNotifier().state, '収入');
    int spending = calcLageCategoryPrice(EventNotifier().state, '支出');
    state = income - spending;
  }

  Future<void> firstCalcTotalAssets() async {
    roomCode = await setRoomCodeFire(uid);
    int income = await firstCalcLageCategoryPrice(roomCode, '収入');
    int spending = await firstCalcLageCategoryPrice(roomCode, '支出');
    state = income - spending;
  }

  void boolChange() {
    first = true;
  }

}
