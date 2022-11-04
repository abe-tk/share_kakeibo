/// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'auth_fire.dart';

final fire = FirebaseFirestore.instance.collection('users');
final doc = FirebaseFirestore.instance.collection('users').doc();

// user情報を取得
Future<Map<String, dynamic>> setUserProfileFire() async {
  final snapshot = await fire.doc(uid).get();
  final data = snapshot.data()!;
  return data;
}

// fireStorageにimgFileを追加
Future<String> putImgFileFire(imgFile) async {
  final task = await FirebaseStorage.instance.ref('users/${doc.id}').putFile(imgFile!);
  final imgURL = await task.ref.getDownloadURL();
  return imgURL;
}

// Userの名前を更新
Future<void> updateUserNameFire(name, code) async {
  await fire.doc(uid).update({
    'userName': name,
  });
  await fire.doc(code).collection('room').doc(uid).update({
    'userName': name,
  });
}

// userのemailを変更
Future<void> updateUserEmailFire(newEmail) async {
  await FirebaseAuth.instance.currentUser!.updateEmail(newEmail!);
  await fire.doc(uid).update({
    'email': newEmail,
  });
}

// userのpasswordを変更
Future<void> updateUserPasswordFire(newPassword) async {
  await FirebaseAuth.instance.currentUser!.updatePassword(newPassword!);
}

// Userのプロフィール画像を更新
Future<void> updateUserImgURLFire(imgURL, code) async {
  await fire.doc(uid).update({
    'imgURL': imgURL,
  });
  await fire.doc(code).collection('room').doc(uid).update({
    'imgURL': imgURL,
  });
}

// userのroomCodeを更新
Future<void> updateUserRoomCodeFire(roomCode) async {
  await fire.doc(uid).update({
    'roomCode': roomCode,
  });
}

// User名更新に伴い、過去登録した収支イベントの名前を更新
Future<void> updatePastEventUserName(code, oldName, newName) async {
  await fire.doc(code).collection('events').where('paymentUser', isEqualTo: oldName).get()
      .then((QuerySnapshot snapshot) async {
    for (var doc in snapshot.docs) {
      await fire.doc(code).collection('events').doc(doc.id).update({
        'paymentUser': newName,
      });
    }
  });
}

