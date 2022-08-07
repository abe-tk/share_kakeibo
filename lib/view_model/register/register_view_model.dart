/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_kakeibo/components/auth_fire.dart';

final registerViewModelProvider = ChangeNotifierProvider((ref) =>
    RegisterViewModel());

class RegisterViewModel extends ChangeNotifier {

  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? userName;
  String? email;
  String? password;

  void setUserName(String userName) {
    this.userName = userName;
  }

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }

  void clearUserName() {
    userNameController.clear();
  }

  void clearEmail() {
    emailController.clear();
  }

  void clearPassword() {
    passwordController.clear();
  }

  Future signUp() async {
    userName = userNameController.text;
    email = emailController.text;
    password = passwordController.text;

    if (userName == null || userName == '') {
      throw 'ユーザー名が入力されていません';
    } else if (email == null || email == '') {
      throw 'メールアドレスが入力されていません';
    } else if (password == null || password == '') {
      throw 'パスワードが入力されていません';
    } else {
      if (email != null && password != null) {
        // app.dartでサインインの状態で判定されないようにするため
        registered(false);
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);
        final user = userCredential.user;

        if (user != null) {
          final uid = user.uid;

          // userの登録
          final userDoc = FirebaseFirestore.instance.collection('users').doc(
              uid);
          await userDoc.set({
            'email': email,
            'imgURL': 'https://kotonohaworks.com/free-icons/wp-content/uploads/kkrn_icon_user_11.png',
            'roomCode': uid,
            'roomName': '$userNameのルーム',
            'userName': userName,
          });

          // roomの登録
          final roomDoc = FirebaseFirestore.instance.collection('users').doc(
              uid).collection('room').doc(uid);
          await roomDoc.set({
            'imgURL': 'https://kotonohaworks.com/free-icons/wp-content/uploads/kkrn_icon_user_11.png',
            'owner': true,
            'userName': userName,
          });

        }
      }
    }
    // app.dartでサインインの状態で判定されないようにするため
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }

}
