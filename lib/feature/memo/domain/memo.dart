import 'package:freezed_annotation/freezed_annotation.dart';
part 'memo.freezed.dart';

@freezed
class Memo with _$Memo {
  const factory Memo({
    required String id,
    required String memo,
    required DateTime date,
    required bool completed,
  }) = _Memo;
}
