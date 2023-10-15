import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepositoryImpl(),
);

class AuthRepositoryImpl extends AuthRepository {
  // 利用する外部サービスの指定
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> singIn({
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
  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
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

  @override
  Stream<User?> checkSignIn() {
    return _auth.authStateChanges();
  }
}
