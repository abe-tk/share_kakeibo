import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/importer.dart';

// FireStore（ルーム情報、ルームメンバー関連）のメンバ関数
class RoomFire {

  // ルームコードの取得
  Future<String> getRoomCodeFire(String uid) async {
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    return data?['roomCode'];
  }

}
