import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/room/data/room_member_repository.dart';
import 'package:share_kakeibo/importer.dart';

final roomMemberRepositoryProvider = Provider(
  (ref) => RoomMemberRepositoryImpl(),
);

class RoomMemberRepositoryImpl extends RoomMemberRepository {
  // 利用する外部サービスの指定
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<RoomMember>> readRoomMember({
    required String roomCode,
  }) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(roomCode)
          .collection('room')
          .get();
      final roomMember = snapshot.docs
          .map((doc) => RoomMember(
                userName: doc['userName'],
                imgURL: doc['imgURL'],
                owner: doc['owner'],
              ))
          .toList();
      return roomMember;
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> joinRoom({
    required String roomCode,
    required String uid,
    required String userName,
    required String imgURL,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(roomCode)
          .collection('room')
          .doc(uid)
          .set({
        'userName': userName,
        'imgURL': imgURL,
        'owner': false,
      });
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> exitRoom({
    required String roomCode,
    required String uid,
    required String userName,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(roomCode)
          .collection('events')
          .where('paymentUser', isEqualTo: userName)
          .get()
          .then((QuerySnapshot snapshot) {
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
      await FirebaseFirestore.instance
          .collection('users')
          .doc(roomCode)
          .collection('room')
          .doc(uid)
          .delete();
      // 退出するユーザーのroomCodeを自身のuidに変更
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'roomCode': uid,
      });
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
