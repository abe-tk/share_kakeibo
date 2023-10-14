import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  // サインイン
  Future<void> singIn({
    required String email,
    required String password,
  });

  // 新規アカウントの登録
  Future<UserCredential> register({
    required String email,
    required String password,
  });

  // パスワード再設定メールの送信
  Future<void> resetPassword({
    required String email,
  });

  // アカウントのメールアドレス変更、パスワード変更、アカウント削除時に再認証
  Future<void> reSingIn({
    required String email,
    required String password,
  });

  // サインアウト
  Future<void> signOut();

  /// 認証状態の確認
  Stream<User?> checkSignIn();
}
