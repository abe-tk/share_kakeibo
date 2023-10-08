import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/user/data/user_repository.dart';
import 'package:share_kakeibo/importer.dart';

final userRepositoryProvider = Provider(
  (ref) => UserRepositoryImpl(),
);

class UserRepositoryImpl extends UserRepository {
  // 利用する外部サービスの指定
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<UserData?> readUser({
    required String uid,
  }) async {
    try {
      final doc = _firestore.collection('users').doc(uid).withConverter(
            fromFirestore: UserData.fromFirestore,
            toFirestore: (UserData userData, _) => userData.toFirestore(),
          );
      final docSnap = await doc.get();
      return docSnap.data();
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> updateUser({
    String? uid,
    String? roomCode,
    UserData? userData,
    String? userName,
    String? imgURL,
    String? imgFilePath,
    String? email,
    String? newRoomCode,
  }) async {
    // 自身のユーザ情報
    final _user = _firestore.collection('users').doc(uid);
    // userコレクションにあるルームのユーザ情報
    final _myRoom =
        _firestore.collection('users').doc(uid).collection('room').doc(uid);
    // 所属しているルームのユーザ情報
    final _inRoom = _firestore
        .collection('users')
        .doc(roomCode)
        .collection('room')
        .doc(uid);
    try {
      // ユーザ名に変更があれば更新
      if (userName != null &&
          userData != null &&
          userName != userData.userName &&
          userName != '') {
        await _user.update({'userName': userName});
        await _myRoom.update({'userName': userName});
        await _inRoom.update({'userName': userName});
        // User名更新に伴い、過去登録した収支イベントの名前を更新
        await _firestore
            .collection('users')
            .doc(roomCode)
            .collection('events')
            .where('paymentUser', isEqualTo: userData.userName)
            .get()
            .then((QuerySnapshot snapshot) async {
          for (var doc in snapshot.docs) {
            await _firestore
                .collection('users')
                .doc(roomCode)
                .collection('events')
                .doc(doc.id)
                .update({
              'paymentUser': userName,
            });
          }
        });
      }
      // プロフィール画像に変更があれば更新
      if (imgFilePath != null && imgFilePath != '') {
        await _user.update({'imgURL': imgURL});
        await _myRoom.update({'imgURL': imgURL});
        await _inRoom.update({'imgURL': imgURL});
      }
      // メールアドレスに変更があれば更新
      if (email != null &&
          userData != null &&
          email != userData.email &&
          email != '') {
        await _auth.currentUser!.updateEmail(email);
        await _user.update({'email': email});
      }
      // ルームコードに変更があれば更新
      if (newRoomCode != null) {
        await _user.update({'roomCode': newRoomCode});
      }
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> updatePassword({
    required String password,
  }) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
