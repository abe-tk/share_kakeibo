import 'package:share_kakeibo/importer.dart';

abstract class RoomNameRepository {
  // ルーム名の取得
  Future<String> readRoomName({
    required String roomCode,
  });

  // ルーム名の更新
  Future<void> updateRoomName({
    required String roomCode,
    required String newRoomName,
  });
}
