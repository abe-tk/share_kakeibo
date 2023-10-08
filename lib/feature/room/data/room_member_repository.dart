import 'package:share_kakeibo/importer.dart';

abstract class RoomMemberRepository {
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
