import 'package:share_kakeibo/feature/room/domain/room_member.dart';

abstract class RoomRepository {
  // ルームの作成
  Future<void> createRoom({
    required String uid,
    required String userName,
    required String imgURL,
  });

  // ルーム名の取得
  Future<String> readRoomName({
    required String roomCode,
  });

  // ルーム名の更新
  Future<void> updateRoomName({
    required String roomCode,
    required String newRoomName,
  });

  // ルームメンバーリストの取得
  Future<List<RoomMember>> readRoomMember({
    required String roomCode,
  });

  // ルームに参加
  Future<void> joinRoom({
    required String roomCode,
    required String uid,
    required String userName,
    required String imgURL,
  });

  // ルームから退出
  Future<void> exitRoom({
    required String roomCode,
    required String uid,
    required String userName,
  });
}
