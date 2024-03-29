// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Memo _$MemoFromJson(Map<String, dynamic> json) {
  return _Memo.fromJson(json);
}

/// @nodoc
mixin _$Memo {
  String get id => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get registerDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MemoCopyWith<Memo> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoCopyWith<$Res> {
  factory $MemoCopyWith(Memo value, $Res Function(Memo) then) =
      _$MemoCopyWithImpl<$Res, Memo>;
  @useResult
  $Res call(
      {String id, String memo, @TimestampConverter() DateTime registerDate});
}

/// @nodoc
class _$MemoCopyWithImpl<$Res, $Val extends Memo>
    implements $MemoCopyWith<$Res> {
  _$MemoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memo = null,
    Object? registerDate = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      registerDate: null == registerDate
          ? _value.registerDate
          : registerDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_MemoCopyWith<$Res> implements $MemoCopyWith<$Res> {
  factory _$$_MemoCopyWith(_$_Memo value, $Res Function(_$_Memo) then) =
      __$$_MemoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String memo, @TimestampConverter() DateTime registerDate});
}

/// @nodoc
class __$$_MemoCopyWithImpl<$Res> extends _$MemoCopyWithImpl<$Res, _$_Memo>
    implements _$$_MemoCopyWith<$Res> {
  __$$_MemoCopyWithImpl(_$_Memo _value, $Res Function(_$_Memo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? memo = null,
    Object? registerDate = null,
  }) {
    return _then(_$_Memo(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      registerDate: null == registerDate
          ? _value.registerDate
          : registerDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Memo implements _Memo {
  const _$_Memo(
      {required this.id,
      required this.memo,
      @TimestampConverter() required this.registerDate});

  factory _$_Memo.fromJson(Map<String, dynamic> json) => _$$_MemoFromJson(json);

  @override
  final String id;
  @override
  final String memo;
  @override
  @TimestampConverter()
  final DateTime registerDate;

  @override
  String toString() {
    return 'Memo(id: $id, memo: $memo, registerDate: $registerDate)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Memo &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.registerDate, registerDate) ||
                other.registerDate == registerDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, memo, registerDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_MemoCopyWith<_$_Memo> get copyWith =>
      __$$_MemoCopyWithImpl<_$_Memo>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MemoToJson(
      this,
    );
  }
}

abstract class _Memo implements Memo {
  const factory _Memo(
      {required final String id,
      required final String memo,
      @TimestampConverter() required final DateTime registerDate}) = _$_Memo;

  factory _Memo.fromJson(Map<String, dynamic> json) = _$_Memo.fromJson;

  @override
  String get id;
  @override
  String get memo;
  @override
  @TimestampConverter()
  DateTime get registerDate;
  @override
  @JsonKey(ignore: true)
  _$$_MemoCopyWith<_$_Memo> get copyWith => throw _privateConstructorUsedError;
}
