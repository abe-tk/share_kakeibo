import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

final roomServiceProvider = Provider<RoomService>(
  (ref) => RoomService(repository: ref.watch(roomRepositoryProvider)),
);

class RoomService {
  RoomService({
    required RoomRepository repository,
  }) : _repository = repository;

  final RoomRepository _repository;

  Future<void> createRoom({
    required String uid,
    required String userName,
    required String email,
    required String imgURL,
  }) async {
    await _repository.createRoom(
      uid: uid,
      userName: userName,
      imgURL: imgURL,
    );
  }
}
