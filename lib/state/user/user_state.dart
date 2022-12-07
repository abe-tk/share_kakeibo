import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/firebase/user_fire.dart';

final userProvider =
StateNotifierProvider<UserNotifier, Map<String, dynamic>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<Map<String, dynamic>> {
  UserNotifier() : super({});

  Future<void> fetchUser() async {
    state = await UserFire().getUserProfileFire();
  }

}
