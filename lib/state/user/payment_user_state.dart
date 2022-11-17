import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final paymentUserProvider =
StateNotifierProvider<PaymentUserNotifier, List<String>>((ref) {
  return PaymentUserNotifier();
});

class PaymentUserNotifier extends StateNotifier<List<String>> {
  PaymentUserNotifier() : super([]);

  Future fetchPaymentUser() async {
    // 支払い元ユーザのlistを作成
    List<String> paymentUserList = [];
    for (int i = 0; i < RoomMemberNotifier().state.length; i++) {
      paymentUserList.add(
          RoomMemberNotifier().state[i].userName
      );
    }
    state = paymentUserList;
  }

}
