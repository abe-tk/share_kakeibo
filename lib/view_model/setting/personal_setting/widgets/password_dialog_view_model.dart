// constant
import 'package:share_kakeibo/constant/validation.dart';
// firebase
import 'package:share_kakeibo/firebase/login_fire.dart';
// state
import 'package:share_kakeibo/state/user/user_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final passwordDialogViewModelProvider =
StateNotifierProvider<PasswordDialogViewModelNotifier, String>((ref) {
  return PasswordDialogViewModelNotifier();
});

class PasswordDialogViewModelNotifier extends StateNotifier<String> {
  PasswordDialogViewModelNotifier() : super('');

  TextEditingController passwordController = TextEditingController();

  void setPassword(String password) {
    state = password;
  }

  void clearPassword() {
    passwordController.clear();
  }

  Future <void> reSignIn() async {
    passwordValidation(state);
    await signInAuth(UserNotifier().state['email'], state);
    passwordController.clear();
  }

}
