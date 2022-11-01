// firebase
import 'package:share_kakeibo/firebase/user_fire.dart';
// state
import 'package:share_kakeibo/state/user/user_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final emailViewModelProvider =
StateNotifierProvider<EmailViewModeNotifier, String>((ref) {
  return EmailViewModeNotifier();
});

class EmailViewModeNotifier extends StateNotifier<String> {
  EmailViewModeNotifier() : super('');

  String? email;
  TextEditingController emailController = TextEditingController();

  void setEmail(String email) {
    state = email;
  }

  Future<void> fetchEmail() async {
    email = UserNotifier().state['email'];
    state = email!;
    emailController.text = email!;
  }

  Future <void> updateEmail() async {
    state = emailController.text;
    await updateUserEmailFire(state);
  }

}