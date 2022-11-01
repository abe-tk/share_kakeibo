//constant
import 'package:share_kakeibo/constant/validation.dart';
// firebase
import 'package:share_kakeibo/firebase/login_fire.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_kakeibo/firebase/auth_fire.dart';

final loginViewModelProvider =
StateNotifierProvider<LoginViewModeNotifier, Map<String, dynamic>>((ref) {
  return LoginViewModeNotifier();
});

class LoginViewModeNotifier extends StateNotifier<Map<String, dynamic>> {
  LoginViewModeNotifier() : super({});

  String? email;
  String? password;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void setInitialize() {
    state['email'];
    state['password'];
  }

  void setEmail(String email) {
    state['email'] = email;
  }

  void setPassword(String password) {
    state['password'] = password;
  }

  void clearTextController() {
    emailController.clear();
    passwordController.clear();
  }

  Future<void> login() async {
    loginValidation(state['email'], state['password']);
    changeLoginState(true); // app.dartでサインインの状態で判定されるようにする
    await loginFire(state['email'], state['password']);
  }

}
