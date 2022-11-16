import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_kakeibo/impoter.dart';
import 'dart:io';

final profileViewModelProvider =
StateNotifierProvider<ProfileViewModelNotifier, Map<String, dynamic>>((ref) {
  return ProfileViewModelNotifier();
});

class ProfileViewModelNotifier extends StateNotifier<Map<String, dynamic>> {
  ProfileViewModelNotifier() : super({});

  late String roomCode;

  String? userName;
  String? imgURL;
  late String oldName;
  TextEditingController nameController = TextEditingController();

  void setName(String userName) {
    state['userName'] = userName;
  }

  Future<void> pickImg() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      state['imgFile'] = File(pickedFile.path);
    }
  }

  Future<void> fetchProfile() async {
    userName = UserNotifier().state['userName'];
    imgURL = UserNotifier().state['imgURL'];
    state['userName'] = userName!;
    state['imgURL'] = imgURL!;
    state['imgFile'] = null;
    nameController.text = userName!;
    oldName = userName!;
    roomCode = await setRoomCodeFire(uid);
  }

  Future<void> updateProfile() async {
    // ユーザ名が空でなければ更新
    updateUserNameValidation(state['userName']);
    await updateUserNameFire(state['userName'], roomCode);
    // 過去の収支イベントの支払い元の名前を変更
    await updatePastEventUserName(roomCode, oldName, state['userName']);
    // プロフィール画像に変更があれば更新
    if (state['imgFile'] != null) {
      state['imgURL'] = await putImgFileFire(state['imgFile']);
      await updateUserImgURLFire(state['imgURL'], roomCode);
    }
  }

}
