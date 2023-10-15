import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_member.freezed.dart';

@freezed
class RoomMember with _$RoomMember {
  const factory RoomMember({
    required String userName,
    required String imgURL,
    required bool owner,
  }) = _RoomMember;
}
