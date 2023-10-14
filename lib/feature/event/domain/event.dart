import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_kakeibo/util/timestamp_converter.dart';

part 'event.freezed.dart';
part 'event.g.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    @TimestampConverter() required DateTime date,
    @TimestampConverter() required DateTime registerDate,
    required String price,
    required String largeCategory,
    required String smallCategory,
    required String memo,
    required String paymentUser,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
