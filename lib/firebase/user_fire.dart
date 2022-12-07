import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/impoter.dart';

// FireStore（ユーザー関連）のメンバ関数
class UserFire {

  // userの登録
  Future<void> addUserFire(String userName, String email, String uid) async {
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

  // user情報を取得
  Future<Map<String, dynamic>> getUserProfileFire() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data()!;
    return data;
  }

  // Userの名前を更新
  Future<void> updateUserNameFire(String name, String roomCode) async {
    updateUserNameValidation(name);
    // ユーザ情報のユーザ名を更新
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'userName': name,
    });
    // ユーザ情報のユーザ名を更新（ユーザのコレクションにあるルームのユーザ情報）
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('room').doc(uid).update({
      'userName': name,
    });
    // ユーザ情報のユーザ名を更新（所属しているルームのユーザ情報）
    await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('room').doc(uid).update({
      'userName': name,
    });
  }

  // Userのプロフィール画像を更新
  Future<void> updateUserImgURLFire(String imgURL, String roomCode) async {
    // ユーザ情報のプロフィール画像を更新
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'imgURL': imgURL,
    });
    // ユーザ情報のプロフィール画像を更新（ユーザのコレクションにあるルームのユーザ情報）
    await FirebaseFirestore.instance.collection('users').doc(uid).collection('room').doc(uid).update({
      'imgURL': imgURL,
    });
    // ユーザ情報のプロフィール画像を更新（所属しているルームのユーザ情報）
    await FirebaseFirestore.instance.collection('users').doc(roomCode).collection('room').doc(uid).update({
      'imgURL': imgURL,
    });
  }

  // userのemailを更新
  Future<void> updateUserEmailFire(String newEmail) async {
    await AuthFire().updateEmailFire(newEmail);
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'email': newEmail,
    });
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

}
