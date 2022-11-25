import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/impoter.dart';

// final fire = FirebaseFirestore.instance.collection('users');

// ルームコードの取得
Future<String> setRoomCodeFire(String uid) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = snapshot.data();
  return data?['roomCode'];
}

// ルーム参加時に招待コードの確認をするため、ルームオーナーのルームコードを取得
Future<String> setOwnerRoomCodeFire(code) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(code).get();
  final data = snapshot.data();
  return data?['roomCode'];
}

// ルーム名の取得
Future<String> setRoomNameFire(code) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(code).get();
    final roomNameData = snapshot.data();
    return roomNameData!['roomName'];
  } catch  (e) {
    throw '入力した招待コードのルームが存在しません';
  }
}

// ルーム名の変更
Future<void> updateRoomNameFire(code, newRoomName) async {
  await FirebaseFirestore.instance.collection('users').doc(code).update({
    'roomName': newRoomName,
  });
}

// ルームメンバーリストの取得
Future<List<RoomMember>> setRoomMemberFire(code) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(code).collection('room').get();
  final roomMember = snapshot.docs.map((doc) => RoomMember(
    userName: doc['userName'],
    imgURL: doc['imgURL'],
    owner: doc['owner'],
  )).toList();
  return roomMember;
}

// ルームに参加
Future<void> joinRoomFire(code, userName, imgURL) async {
  // ルームに参加するユーザー情報を登録
  await FirebaseFirestore.instance.collection('users').doc(code).collection('room').doc(uid).set({
    'userName': userName,
    'imgURL': imgURL,
    'owner': false,
  });
}

// ルームの退出
Future<void> exitRoomFire(code, userName) async {
  // 「支払い元が退出するユーザー」のイベントを削除
  await FirebaseFirestore.instance.collection('users').doc(code).collection('events').where('paymentUser', isEqualTo: userName).get().then((QuerySnapshot snapshot) {
    for (var doc in snapshot.docs) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(code)
          .collection('events')
          .doc(doc.id)
          .delete();
    }
  });
  // ルームから退出するユーザーの情報を削除
  await FirebaseFirestore.instance.collection('users')
      .doc(code)
      .collection('room')
      .doc(uid)
      .delete();
  // 退出するユーザーのroomCodeを自身のuidに変更
  await FirebaseFirestore.instance.collection('users')
      .doc(uid)
      .update({
    'roomCode': uid,
  });
}
