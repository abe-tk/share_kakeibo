import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:share_kakeibo/impoter.dart';

// user情報を取得
Future<Map<String, dynamic>> getUserProfileFire() async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = snapshot.data()!;
  return data;
}

// Userの名前を更新
Future<void> updateUserNameFire(String name, String roomCode) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'userName': name,
  });
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('room').doc(uid).update({
    'userName': name,
  });
}

// userのemailを更新
Future<void> updateUserEmailFire(String newEmail) async {
  await FirebaseAuth.instance.currentUser!.updateEmail(newEmail);
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'email': newEmail,
  });
}

// userのpasswordを更新
Future<void> updateUserPasswordFire(String newPassword) async {
  await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
}

// Userのプロフィール画像を更新
Future<void> updateUserImgURLFire(String imgURL, String roomCode) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'imgURL': imgURL,
  });
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('room').doc(uid).update({
    'imgURL': imgURL,
  });
}

// fireStorageにimgFileを追加（「Userのプロフィール画像を更新」のため）
Future<String> putImgFileFire(File imgFile) async {
  final task = await FirebaseStorage.instance.ref('users/${FirebaseFirestore.instance.collection('users').doc().id}').putFile(imgFile);
  final imgURL = await task.ref.getDownloadURL();
  return imgURL;
}

// userのroomCodeを更新
Future<void> updateUserRoomCodeFire(String roomCode) async {
  await FirebaseFirestore.instance.collection('users').doc(uid).update({
    'roomCode': roomCode,
  });
}

// User名更新に伴い、過去登録した収支イベントの名前を更新
Future<void> updatePastEventUserName(String roomCode, String oldName, String newName) async {
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').where('paymentUser', isEqualTo: oldName).get()
      .then((QuerySnapshot snapshot) async {
    for (var doc in snapshot.docs) {
      await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').doc(doc.id).update({
        'paymentUser': newName,
      });
    }
  });
}

