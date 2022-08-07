/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailViewModel = ChangeNotifierProvider((ref) => EmailViewModel());

class EmailViewModel extends ChangeNotifier {
  String? email;
  String? newEmail;
  String? password;
  TextEditingController passwordController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();

  void setEmail(String newEmail) {
    this.newEmail = newEmail;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void clearPassword() {
    passwordController.clear();
    notifyListeners();
  }

  Future<void> fetchEmail() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    email = data?['email'];
    newEmail = data?['email'];
    newEmailController.text = newEmail!;
    notifyListeners();
  }

  void emailValidation() {
    if (newEmail == null || newEmail == "") {
      throw 'メールアドレスが入力されていません';
    } else if (email == newEmail) {
      throw 'メールアドレスの変更がありません';
    }
  }

  Future <void> login() async {
    password = passwordController.text;
    if (password == null || password == "") {
      throw 'パスワードが入力されていません';
    } else {
      if (email != null && password != null) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
        passwordController.clear();
      }
    }
    notifyListeners();
  }

  Future <void> update() async {
    newEmail = newEmailController.text;
    await FirebaseAuth.instance.currentUser!.updateEmail(newEmail!);
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'email': newEmail,
    });
  }

}
