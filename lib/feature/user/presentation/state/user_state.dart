import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/user/data/user_repository.impl.dart';
import 'package:share_kakeibo/importer.dart';

// ユーザー情報を管理するプロバイダ
final userInfoProvider =
    AsyncNotifierProvider<UserInfo, UserData?>(UserInfo.new);

class UserInfo extends AsyncNotifier<UserData?> {
  // refは渡さなくていい

  // ユーザー情報の取得
  Future<UserData?> readUser() async {
    final repository = ref.watch(userRepositoryProvider);
    return repository.readUser(
      uid: ref.watch(uidProvider),
    );
  }

  // 初期データの読み込み
  @override
  FutureOr<UserData?> build() async {
    return await readUser();
  }

  // ユーザー情報の更新
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
    final repository = ref.watch(userRepositoryProvider);

    // Stateに[AsyncLoading()]を代入し非同期処理が開始
    state = const AsyncLoading();

    // その後、処理の結果が[AsyncData()]もしくは[AsyncError()]としてStateに代入される
    state = await AsyncValue.guard(() async {
      await repository.updateUser(
        uid: uid,
        roomCode: roomCode,
        userData: userData,
        userName: userName,
        imgURL: imgURL,
        imgFilePath: imgFilePath,
        email: email,
        newRoomCode: newRoomCode,
      );

      // ユーザー情報の取得更新
      return readUser();
    });
  }
}
