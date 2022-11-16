import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

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

