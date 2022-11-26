import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/impoter.dart';

// ルームコードの取得
Future<String> getRoomCodeFire(String uid) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = snapshot.data();
  return data?['roomCode'];
}

// ルームに参加
Future<void> joinRoomFire(String roomCode, String userName, String imgURL) async {
  // ルームに参加するユーザー情報を登録
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('room').doc(uid).set({
    'userName': userName,
    'imgURL': imgURL,
    'owner': false,
  });
}

// ルームの退出
Future<void> exitRoomFire(String roomCode, String userName) async {
  // 「支払い元が退出するユーザー」のイベントを削除
  await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').where('paymentUser', isEqualTo: userName).get().then((QuerySnapshot snapshot) {
    for (var doc in snapshot.docs) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(roomCode)
          .collection('events')
          .doc(doc.id)
          .delete();
    }
  });
  // ルームから退出するユーザーの情報を削除
  await FirebaseFirestore.instance.collection('users')
      .doc(roomCode)
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

// ルーム名の取得
Future<String> getRoomNameFire(String roomCode) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(roomCode).get();
    final roomNameData = snapshot.data();
    return roomNameData!['roomName'];
  } catch  (e) {
    throw '入力した招待コードのルームが存在しません';
  }
}

// ルーム名の変更
Future<void> updateRoomNameFire(String roomCode, String newRoomName) async {
  await FirebaseFirestore.instance.collection('users').doc(roomCode).update({
    'roomName': newRoomName,
  });
}

// ルームメンバーリストの取得
Future<List<RoomMember>> getRoomMemberFire(String roomCode) async {
  final snapshot = await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('room').get();
  final roomMember = snapshot.docs.map((doc) => RoomMember(
    userName: doc['userName'],
    imgURL: doc['imgURL'],
    owner: doc['owner'],
  )).toList();
  return roomMember;
}