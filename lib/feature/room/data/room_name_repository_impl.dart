import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/room/data/room_name_repository.dart';
import 'package:share_kakeibo/importer.dart';

final roomNameRepositoryProvider = Provider(
  (ref) => RoomNameRepositoryImpl(),
);

class RoomNameRepositoryImpl extends RoomNameRepository {
  // 利用する外部サービスの指定
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> readRoomName({
    required String roomCode,
  }) async {
    try {
      final snapshot = await _firestore.collection('users').doc(roomCode).get();
      final roomNameData = snapshot.data();
      return roomNameData!['roomName'];
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    } catch (e) {
      logger.e(e);
      throw '入力した招待コードのルームが存在しません';
    }
  }

  @override
  Future<void> updateRoomName({
    required String roomCode,
    required String newRoomName,
  }) async {
    try {
      await _firestore.collection('users').doc(roomCode).update({
        'roomName': newRoomName,
      });
    } on FirebaseException catch (e) {
      logger.e(e);
      rethrow;
    } on Exception catch (e) {
      logger.e(e);
      rethrow;
    }
  }
}
