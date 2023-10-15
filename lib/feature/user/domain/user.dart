import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String userName,
    required String imgURL,
    required String email,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);

  factory UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserData(
      userName: data?['userName'],
      imgURL: data?['imgURL'],
      email: data?['email'],
    );
  }

    Map<String, dynamic> toFirestore() {
    return {
      "userName": userName,
      "imgURL": imgURL,
      "email": email,
    };
  }
}
