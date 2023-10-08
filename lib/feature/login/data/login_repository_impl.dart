import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/constant/img_url.dart';
import 'package:share_kakeibo/feature/login/data/login_repository.dart';
import 'package:share_kakeibo/importer.dart';

final loginRepositoryProvider = Provider(
  (ref) => LoginRepositoryImpl(),
);

class LoginRepositoryImpl extends LoginRepository {
  // 利用する外部サービスの指定
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> login({
    required String uidProvider,
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // uidをログインしたユーザのIDに変更
      uidProvider = _auth.currentUser!.uid;
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> register({
    required String uidProvider,
    required String userName,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = userCredential.user?.uid;

      // uidをログインしたユーザのIDに変更
      uidProvider = uid!;

      // ユーザー情報の登録
      await _firestore.collection('users').doc(uid).set({
        'userName': userName,
        'email': email,
        'imgURL': imgURL,
        'roomCode': uid,
        'roomName': '$userNameのルーム',
      });

      // ルーム情報の登録
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('room')
          .doc(uid)
          .set({
        'userName': userName,
        'imgURL': imgURL,
        'owner': true,
      });
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> resetPassword({
    required String email,
  }) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> reSingIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
