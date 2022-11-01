// constant
import 'package:share_kakeibo/constant/validation.dart';
// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/login_fire.dart';
// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final registerViewModelProvider =
StateNotifierProvider<RegisterViewModeNotifier, Map<String, dynamic>>((ref) {
  return RegisterViewModeNotifier();
});

class RegisterViewModeNotifier extends StateNotifier<Map<String, dynamic>> {
  RegisterViewModeNotifier() : super({});

  String? userName;
  String? email;
  String? password;
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void setInitialize() {
    state['userName'];
    state['email'];
    state['password'];
  }

  void setUserName(String userName) {
    state['userName'] = userName;
  }

  void setEmail(String email) {
    state['email'] = email;
  }

  void setPassword(String password) {
    state['password'] = password;
  }

  void clearTextController() {
    userNameController.clear();
    emailController.clear();
    passwordController.clear();
  }

  Future signUp() async {
    registerValidation(state['userName'], state['email'], state['password']);
    changeLoginState(false); // app.dartでサインインの状態で判定されないようにするため
    await registerFire(state['email'], state['password'], state['userName']);
    // app.dartでサインインの状態で判定されないようにするため
    await FirebaseAuth.instance.signOut();
  }

}

