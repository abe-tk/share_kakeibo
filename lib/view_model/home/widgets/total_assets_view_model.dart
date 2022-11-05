// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
import 'package:share_kakeibo/firebase/event_fire.dart';
// state
import 'package:share_kakeibo/state/event/event_state.dart';
// utility
import 'package:share_kakeibo/utility/price_utility.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

final totalAssetsViewModelProvider =
StateNotifierProvider<TotalAssetsViewModelNotifier, int>((ref) {
  return TotalAssetsViewModelNotifier();
});

class TotalAssetsViewModelNotifier extends StateNotifier<int> {
  TotalAssetsViewModelNotifier() : super(0);

  late String roomCode;

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

}
