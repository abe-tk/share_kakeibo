import 'package:freezed_annotation/freezed_annotation.dart';
part 'event.freezed.dart';

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required DateTime date,
    required String price,
    required String largeCategory,
    required String smallCategory,
    required String memo,
    required String paymentUser,
  }) = _Event;
}