import 'package:freezed_annotation/freezed_annotation.dart';
part 'user.freezed.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String userName,
    required String imgURL,
    required String email,
  }) = _UserData;
}
