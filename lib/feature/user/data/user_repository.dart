import 'package:share_kakeibo/importer.dart';

abstract class UserRepository {
  // ユーザー情報を登録
  Future<void> createUser({
    required String uid,
    required String userName,
    required String email,
    required String imgURL,
  });

  // ユーザー情報を取得
  Future<UserData?> readUser({
    required String uid,
  });

  // ユーザー情報を更新
  Future<void> updateUser({
    String? uid,
    String? roomCode,
    UserData? userData,
    String? userName,
    String? imgURL,
    String? imgFilePath,
    String? email,
    String? newRoomCode,
  });

  // パスワードを更新
  Future<void> updatePassword({
    required String password,
  });

  // アカウントの削除
  Future<void> deleteAccount();
}
