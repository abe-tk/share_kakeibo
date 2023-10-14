abstract class LoginRepository {
  // ログイン
  Future<void> login({
    // required String uidProvider,
    required String email,
    required String password,
  });

  // 新規アカウント登録
  Future<void> register({
    required String uidProvider,
    required String userName,
    required String email,
    required String password,
  });

  // パスワード再設定メールの送信
  Future<void> resetPassword({
    required String email,
  });

  // アカウントのメールアドレス変更、パスワード変更、アカウント削除時にReSingIn
  Future<void> reSingIn({
    required String email,
    required String password,
  });

  // ログアウト
  Future<void> signOut();
}
