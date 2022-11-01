import 'package:firebase_auth/firebase_auth.dart';

// ユーザーのID
var uid = FirebaseAuth.instance.currentUser!.uid;

// app.dartでアカウント新規登録後、ログイン状態だと判定されないために用意
var loginState = true;

// ログイン時にuidをユーザーのものに変更する
void changeUid() {
  uid = FirebaseAuth.instance.currentUser!.uid;
}

// アカウント新規登録時にはfalseを返して未ログイン状態と判定させる
// アカウントログイン時にはtureを返してログイン状態と判定させる
void changeLoginState(value) {
  loginState = value;
}

