import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

final userServiceProvider = Provider<UserService>(
  (ref) => UserService(repository: ref.watch(userRepositoryProvider)),
);

class UserService {
  UserService({
    required UserRepository repository,
  }) : _repository = repository;

  final UserRepository _repository;

  Future<void> createUser({
    required String uid,
    required String userName,
    required String email,
    required String imgURL,
  }) async {
    await _repository.createUser(
      uid: uid,
      userName: userName,
      email: email,
      imgURL: imgURL,
    );
  }
}
