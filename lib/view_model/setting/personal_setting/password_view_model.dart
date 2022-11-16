import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final passwordViewModelProvider =
StateNotifierProvider<PasswordViewModeNotifier, Map<String, String>>((ref) {
  return PasswordViewModeNotifier();
});

class PasswordViewModeNotifier extends StateNotifier<Map<String, String>> {
  PasswordViewModeNotifier() : super({});

  TextEditingController passwordController = TextEditingController();
  TextEditingController checkPasswordController = TextEditingController();

  void setInitialize() {
    state['password'] = '';
    state['checkPassword'] = '';
    passwordController.text = state['password']!;
    checkPasswordController.text = state['checkPassword']!;
  }

  void setPassword(String password) {
    state['password'] = password;
  }

  void setCheckPassword(String checkPassword) {
    state['checkPassword'] = checkPassword;
  }

  Future <void> updatePassword() async {
    await updateUserPasswordFire(state['password']);
  }

}