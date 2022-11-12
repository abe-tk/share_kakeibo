// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/firebase/user_fire.dart';

Map<String, dynamic> userProfile = {};

final userProvider =
StateNotifierProvider<UserNotifier, Map<String, dynamic>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<Map<String, dynamic>> {
  UserNotifier() : super(userProfile);

  Future<void> fetchUser() async {
    userProfile = await setUserProfileFire();
    state = userProfile;
  }

}
