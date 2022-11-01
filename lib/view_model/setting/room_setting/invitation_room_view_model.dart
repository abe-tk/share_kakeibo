// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

final invitationRoomViewModelProvider =
StateNotifierProvider<InvitationRoomViewModelNotifier, String>((ref) {
  return InvitationRoomViewModelNotifier();
});

class InvitationRoomViewModelNotifier extends StateNotifier<String> {
  InvitationRoomViewModelNotifier() : super('');

  Future<void> fetchRoomInfo() async {
    state = await setRoomCodeFire(uid);
  }

}
