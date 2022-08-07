/// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_kakeibo/components/auth_fire.dart';

final loginViewModelProvider = ChangeNotifierProvider((ref) => LoginViewModel());

class LoginViewModel extends ChangeNotifier {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? email;
  String? password;

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void clearEmail() {
    emailController.clear();
    notifyListeners();
  }

  void clearPassword() {
    passwordController.clear();
    notifyListeners();
  }

  Future login() async {
    email = emailController.text;
    password = passwordController.text;

    if (email == null || email == "") {
      throw 'メールアドレスが入力されていません';
    } else if (password == null || password == "") {
      throw 'パスワードが入力されていません';
    } else {
      registered(true);
      if (email != null && password != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
      }
    }
    notifyListeners();
  }

}
