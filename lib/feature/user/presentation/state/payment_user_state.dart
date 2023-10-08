import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

final paymentUserProvider =
StateNotifierProvider<PaymentUserNotifier, List<String>>((ref) {
  return PaymentUserNotifier();
});

class PaymentUserNotifier extends StateNotifier<List<String>> {
  PaymentUserNotifier() : super([]);

  Future fetchPaymentUser(List<RoomMember> roomMember) async {
    // 支払い元ユーザのlistを作成
    List<String> paymentUserList = [];
    for (int i = 0; i < roomMember.length; i++) {
      paymentUserList.add(
          roomMember[i].userName
      );
    }
    state = paymentUserList;
  }

}
