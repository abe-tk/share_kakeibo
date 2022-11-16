import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final qrScanViewModelProvider =
StateNotifierProvider<QrScanViewModelNotifier, String>((ref) {
  return QrScanViewModelNotifier();
});

class QrScanViewModelNotifier extends StateNotifier<String> {
  QrScanViewModelNotifier() : super('');

  String? ownerRoomCode;
  String? ownerRoomName;

  Future<void> joinRoom(String code) async {
    state = code;
    ownerRoomCode = await setOwnerRoomCodeFire(state);
    ownerRoomName = await setRoomNameFire(state);
    invitationRoomValidation(state, ownerRoomCode);
    updateUserRoomCodeFire(state);
    joinRoomFire(state, UserNotifier().state['userName'], UserNotifier().state['imgURL']);
  }

}

