// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/price_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

final totalAssetsProvider =
    StateNotifierProvider<TotalAssetsNotifier, int>((ref) {
  return TotalAssetsNotifier();
});

class TotalAssetsNotifier extends StateNotifier<int> {
  TotalAssetsNotifier() : super(0);

  late String roomCode;
  int income = 0;
  int spending = 0;

  Future<int> calcTotalAssets() async {
    roomCode = await setRoomCodeFire(uid);
    income = await setTotalLageCategoryPriceFire('収入', roomCode);
    spending = await setTotalLageCategoryPriceFire('支出', roomCode);
    return state = income - spending;
  }
}
