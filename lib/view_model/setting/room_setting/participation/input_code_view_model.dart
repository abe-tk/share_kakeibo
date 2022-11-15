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

final inputCodeViewModelProvider =
StateNotifierProvider<InputCodeViewModelNotifier, String>((ref) {
  return InputCodeViewModelNotifier();
});

class InputCodeViewModelNotifier extends StateNotifier<String> {
  InputCodeViewModelNotifier() : super('');

  // String? roomCode;
  TextEditingController roomCodeController = TextEditingController();

  String? ownerRoomCode;
  String? ownerRoomName;

  void setRoomCode(String roomCode) {
    state = roomCode;
  }

  void clearRoomCode() {
    state = '';
    roomCodeController.clear();
  }

  Future<void> joinRoom() async {
    state = roomCodeController.text;
    ownerRoomCode = await setOwnerRoomCodeFire(state);
    ownerRoomName = await setRoomNameFire(state);
    invitationRoomValidation(state, ownerRoomCode);
    updateUserRoomCodeFire(state);
    joinRoomFire(state, UserNotifier().state['userName'], UserNotifier().state['imgURL']);
  }

}

