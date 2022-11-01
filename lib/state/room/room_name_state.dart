// constant
import 'package:share_kakeibo/constant/validation.dart';
// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final roomNameProvider = StateNotifierProvider<RoomNameNotifier, String>((ref) {
  return RoomNameNotifier();
});

class RoomNameNotifier extends StateNotifier<String> {
  RoomNameNotifier() : super('');

  late String roomCode;
  String? newRoomName;
  TextEditingController roomNameController = TextEditingController();

  Future<void> fetchRoomName() async {
    roomCode = await setRoomCodeFire(uid);
    state = await setRoomNameFire(roomCode);
    newRoomName = state;
    roomNameController.text = state;
  }

  void setRoomName(String roomName) {
    newRoomName = roomName;
  }

  Future<void> changeRoomName() async {
    changeRoomNameValidation(newRoomName);
    await updateRoomNameFire(roomCode, newRoomName);
    state = newRoomName!;
  }

}
