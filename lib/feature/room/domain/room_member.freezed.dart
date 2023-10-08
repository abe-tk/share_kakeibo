// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RoomMember {
  String get userName => throw _privateConstructorUsedError;
  String get imgURL => throw _privateConstructorUsedError;
  bool get owner => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoomMemberCopyWith<RoomMember> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoomMemberCopyWith<$Res> {
  factory $RoomMemberCopyWith(
          RoomMember value, $Res Function(RoomMember) then) =
      _$RoomMemberCopyWithImpl<$Res, RoomMember>;
  @useResult
  $Res call({String userName, String imgURL, bool owner});
}

/// @nodoc
class _$RoomMemberCopyWithImpl<$Res, $Val extends RoomMember>
    implements $RoomMemberCopyWith<$Res> {
  _$RoomMemberCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? imgURL = null,
    Object? owner = null,
  }) {
    return _then(_value.copyWith(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      imgURL: null == imgURL
          ? _value.imgURL
          : imgURL // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_RoomMemberCopyWith<$Res>
    implements $RoomMemberCopyWith<$Res> {
  factory _$$_RoomMemberCopyWith(
          _$_RoomMember value, $Res Function(_$_RoomMember) then) =
      __$$_RoomMemberCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userName, String imgURL, bool owner});
}

/// @nodoc
class __$$_RoomMemberCopyWithImpl<$Res>
    extends _$RoomMemberCopyWithImpl<$Res, _$_RoomMember>
    implements _$$_RoomMemberCopyWith<$Res> {
  __$$_RoomMemberCopyWithImpl(
      _$_RoomMember _value, $Res Function(_$_RoomMember) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? imgURL = null,
    Object? owner = null,
  }) {
    return _then(_$_RoomMember(
      userName: null == userName
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      imgURL: null == imgURL
          ? _value.imgURL
          : imgURL // ignore: cast_nullable_to_non_nullable
              as String,
      owner: null == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_RoomMember implements _RoomMember {
  const _$_RoomMember(
      {required this.userName, required this.imgURL, required this.owner});

  @override
  final String userName;
  @override
  final String imgURL;
  @override
  final bool owner;

  @override
  String toString() {
    return 'RoomMember(userName: $userName, imgURL: $imgURL, owner: $owner)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RoomMember &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.imgURL, imgURL) || other.imgURL == imgURL) &&
            (identical(other.owner, owner) || other.owner == owner));
  }

  @override
  int get hashCode => Object.hash(runtimeType, userName, imgURL, owner);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RoomMemberCopyWith<_$_RoomMember> get copyWith =>
      __$$_RoomMemberCopyWithImpl<_$_RoomMember>(this, _$identity);
}

abstract class _RoomMember implements RoomMember {
  const factory _RoomMember(
      {required final String userName,
      required final String imgURL,
      required final bool owner}) = _$_RoomMember;

  @override
  String get userName;
  @override
  String get imgURL;
  @override
  bool get owner;
  @override
  @JsonKey(ignore: true)
  _$$_RoomMemberCopyWith<_$_RoomMember> get copyWith =>
      throw _privateConstructorUsedError;
}
