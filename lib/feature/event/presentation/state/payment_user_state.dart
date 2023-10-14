import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class PaymentUsersNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    final roomMember =
        ref.watch(roomMemberProvider).whenOrNull(data: (data) => data) ?? [];
    List<String> paymentUsers = [];
    for (int i = 0; i < roomMember.length; i++) {
      paymentUsers.add(roomMember[i].userName);
    }
    return paymentUsers;
  }
}

final paymentUsers =
    NotifierProvider<PaymentUsersNotifier, List<String>>(
  () => PaymentUsersNotifier(),
);
