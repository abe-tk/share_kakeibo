import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/impoter.dart';

// アカウントへログイン
Future<void> loginFire(email, password) async {
  loginValidation(email, password);
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
}

// アカウントの新規登録
Future<void> registerFire(email, password, userName) async {
  registerValidation(userName, email, password);
  final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email!, password: password!);
  final user = userCredential.user;
  final uid = user?.uid;
  // userの登録
  final userDoc = FirebaseFirestore.instance.collection('users').doc(uid);
  await userDoc.set({
    'userName': userName,
    'email': email,
    'imgURL': 'https://firebasestorage.googleapis.com/v0/b/sharekakeibo-59b13.appspot.com/o/users%2Fuser_icon.png?alt=media&token=a3bd368c-58d4-4945-bf38-f8bc57fc4144',
    'roomCode': uid,
    'roomName': '$userNameのルーム',
  });
  // roomの登録
  final roomDoc = FirebaseFirestore.instance.collection('users').doc(uid).collection('room').doc(uid);
  await roomDoc.set({
    'userName': userName,
    'imgURL': 'https://firebasestorage.googleapis.com/v0/b/sharekakeibo-59b13.appspot.com/o/users%2Fuser_icon.png?alt=media&token=a3bd368c-58d4-4945-bf38-f8bc57fc4144',
    'owner': true,
  });
}

// アカウントのログアウト、削除時に再ログイン確認
Future<void> signInAuth(email, password) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(email: email!, password: password!);
}
