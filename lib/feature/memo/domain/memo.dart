import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_kakeibo/importer.dart';

part 'memo.freezed.dart';
part 'memo.g.dart';

@freezed
class Memo with _$Memo {
  const factory Memo({
    required String id,
    required String memo,
    @TimestampConverter() required DateTime registerDate,
  }) = _Memo;

    factory Memo.fromJson(Map<String, dynamic> json) =>
      _$MemoFromJson(json);
}
