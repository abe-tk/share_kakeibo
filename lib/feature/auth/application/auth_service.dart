import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/auth/data/auth_repository.dart';
import 'package:share_kakeibo/feature/auth/data/auth_repository_impl.dart';

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(repository: ref.watch(authRepositoryProvider)),
);

class AuthService {
  AuthService({
    required AuthRepository repository,
  }) : _repository = repository;

  final AuthRepository _repository;

  Future<void> singIn({
    required String email,
    required String password,
  }) async {
    await _repository.singIn(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> register({
    required String email,
    required String password,
  }) async {
    final userCredential = await _repository.register(
      email: email,
      password: password,
    );
    return userCredential;
  }

  Future<void> resetPassword({
    required String email,
  }) async {
    await _repository.resetPassword(
      email: email,
    );
  }

  Future<void> reSingIn({
    required String email,
    required String password,
  }) {
    return _repository.reSingIn(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() {
    return _repository.signOut();
  }

  Stream<User?> checkSignIn() {
    return _repository.checkSignIn();
  }

/*
MEMO(abe-tk):
23/07/20時点でFlutter3.10系だとFirebaseAuthで返ってくるエラーコードがunknownになるバグがあるが、
firebaseHostingへデプロイした環境では正常にエラーコードが返ってくる。
issue：https://github.com/firebase/flutterfire/issues/10966

getErrorMessage 'e.code'を参照してエラーメッセージを返すメソッド
*/
  String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'メールアドレスが無効です';
      case 'user-not-found':
        return 'ユーザーが存在しません';
      case 'wrong-password':
        return 'パスワードが間違っています';
      case 'weak-password':
        return 'パスワードは6桁以上にしてください';
      case 'email-already-in-use':
        return 'すでに使用されているメールアドレスです';
      default:
        return 'エラー';
    }
  }
}
