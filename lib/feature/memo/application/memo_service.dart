import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/feature/memo/data/memo_repository.dart';
import 'package:share_kakeibo/feature/memo/data/memo_repository_impl.dart';
import 'package:share_kakeibo/util/validator/validator.dart';

final memoService = Provider<MemoService>(
  (ref) => MemoService(repository: ref.watch(memoRepositoryProvider)),
);

class MemoService {
  MemoService({
    required MemoRepository repository,
  }) : _repository = repository;

  final MemoRepository _repository;

  Future<void> createMemo({
    required String roomCode,
    required String memo,
  }) async {
    memoValidation(memo);
    await _repository.createMemo(roomCode: roomCode, memo: memo);
  }

  Future<void> deleteMemo({
    required String roomCode,
    required String id,
  }) async {
    await _repository.deleteMemo(roomCode: roomCode, id: id);
  }
}
