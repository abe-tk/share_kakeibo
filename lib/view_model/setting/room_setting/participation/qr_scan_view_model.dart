// constant
import 'package:share_kakeibo/constant/validation.dart';
// firebase
import 'package:share_kakeibo/firebase/room_fire.dart';
import 'package:share_kakeibo/firebase/user_fire.dart';
// state
import 'package:share_kakeibo/state/user/user_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

