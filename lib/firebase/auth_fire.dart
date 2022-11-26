import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/impoter.dart';

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
void changeLoginState(bool value) {
  loginState = value;
}

// アカウントへログイン
Future<void> loginFire(String email, String password) async {
  loginValidation(email, password);
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
}

// アカウントの新規登録
Future<void> registerFire(String userName, String email, String password) async {
  registerValidation(userName, email, password);
  final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  final user = userCredential.user;
  final uid = user?.uid;
  // user情報の登録
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  await userDoc.set({
    'userName': userName,
    'email': email,
    'imgURL': 'https://firebasestorage.googleapis.com/v0/b/sharekakeibo-59b13.appspot.com/o/users%2Fuser_icon.png?alt=media&token=a3bd368c-58d4-4945-bf38-f8bc57fc4144',
    'roomCode': uid,
    'roomName': '$userNameのルーム',
  });
  // userのroom情報の登録
  final roomDoc = FirebaseFirestore.instance.collection('users').doc(uid).collection('room').doc(uid);
  await roomDoc.set({
    'userName': userName,
    'imgURL': 'https://firebasestorage.googleapis.com/v0/b/sharekakeibo-59b13.appspot.com/o/users%2Fuser_icon.png?alt=media&token=a3bd368c-58d4-4945-bf38-f8bc57fc4144',
    'owner': true,
  });
}

// アカウントのメールアドレス変更、パスワード変更、アカウント削除時にReSingIn
Future<void> reSingInFire(String email, String password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
}