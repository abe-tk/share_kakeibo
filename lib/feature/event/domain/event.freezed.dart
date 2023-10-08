// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Event _$EventFromJson(Map<String, dynamic> json) {
  return _Event.fromJson(json);
}

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get date => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get registerDate => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;
  String get largeCategory => throw _privateConstructorUsedError;
  String get smallCategory => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  String get paymentUser => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res, Event>;
  @useResult
  $Res call(
      {String id,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime registerDate,
      String price,
      String largeCategory,
      String smallCategory,
      String memo,
      String paymentUser});
}

/// @nodoc
class _$EventCopyWithImpl<$Res, $Val extends Event>
    implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? registerDate = null,
    Object? price = null,
    Object? largeCategory = null,
    Object? smallCategory = null,
    Object? memo = null,
    Object? paymentUser = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registerDate: null == registerDate
          ? _value.registerDate
          : registerDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      largeCategory: null == largeCategory
          ? _value.largeCategory
          : largeCategory // ignore: cast_nullable_to_non_nullable
              as String,
      smallCategory: null == smallCategory
          ? _value.smallCategory
          : smallCategory // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      paymentUser: null == paymentUser
          ? _value.paymentUser
          : paymentUser // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$_EventCopyWith(_$_Event value, $Res Function(_$_Event) then) =
      __$$_EventCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @TimestampConverter() DateTime date,
      @TimestampConverter() DateTime registerDate,
      String price,
      String largeCategory,
      String smallCategory,
      String memo,
      String paymentUser});
}

/// @nodoc
class __$$_EventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res, _$_Event>
    implements _$$_EventCopyWith<$Res> {
  __$$_EventCopyWithImpl(_$_Event _value, $Res Function(_$_Event) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? registerDate = null,
    Object? price = null,
    Object? largeCategory = null,
    Object? smallCategory = null,
    Object? memo = null,
    Object? paymentUser = null,
  }) {
    return _then(_$_Event(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registerDate: null == registerDate
          ? _value.registerDate
          : registerDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      largeCategory: null == largeCategory
          ? _value.largeCategory
          : largeCategory // ignore: cast_nullable_to_non_nullable
              as String,
      smallCategory: null == smallCategory
          ? _value.smallCategory
          : smallCategory // ignore: cast_nullable_to_non_nullable
              as String,
      memo: null == memo
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      paymentUser: null == paymentUser
          ? _value.paymentUser
          : paymentUser // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Event implements _Event {
  const _$_Event(
      {required this.id,
      @TimestampConverter() required this.date,
      @TimestampConverter() required this.registerDate,
      required this.price,
      required this.largeCategory,
      required this.smallCategory,
      required this.memo,
      required this.paymentUser});

  factory _$_Event.fromJson(Map<String, dynamic> json) =>
      _$$_EventFromJson(json);

  @override
  final String id;
  @override
  @TimestampConverter()
  final DateTime date;
  @override
  @TimestampConverter()
  final DateTime registerDate;
  @override
  final String price;
  @override
  final String largeCategory;
  @override
  final String smallCategory;
  @override
  final String memo;
  @override
  final String paymentUser;

  @override
  String toString() {
    return 'Event(id: $id, date: $date, registerDate: $registerDate, price: $price, largeCategory: $largeCategory, smallCategory: $smallCategory, memo: $memo, paymentUser: $paymentUser)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Event &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.registerDate, registerDate) ||
                other.registerDate == registerDate) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.largeCategory, largeCategory) ||
                other.largeCategory == largeCategory) &&
            (identical(other.smallCategory, smallCategory) ||
                other.smallCategory == smallCategory) &&
            (identical(other.memo, memo) || other.memo == memo) &&
            (identical(other.paymentUser, paymentUser) ||
                other.paymentUser == paymentUser));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, date, registerDate, price,
      largeCategory, smallCategory, memo, paymentUser);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_EventCopyWith<_$_Event> get copyWith =>
      __$$_EventCopyWithImpl<_$_Event>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_EventToJson(
      this,
    );
  }
}

abstract class _Event implements Event {
  const factory _Event(
      {required final String id,
      @TimestampConverter() required final DateTime date,
      @TimestampConverter() required final DateTime registerDate,
      required final String price,
      required final String largeCategory,
      required final String smallCategory,
      required final String memo,
      required final String paymentUser}) = _$_Event;

  factory _Event.fromJson(Map<String, dynamic> json) = _$_Event.fromJson;

  @override
  String get id;
  @override
  @TimestampConverter()
  DateTime get date;
  @override
  @TimestampConverter()
  DateTime get registerDate;
  @override
  String get price;
  @override
  String get largeCategory;
  @override
  String get smallCategory;
  @override
  String get memo;
  @override
  String get paymentUser;
  @override
  @JsonKey(ignore: true)
  _$$_EventCopyWith<_$_Event> get copyWith =>
      throw _privateConstructorUsedError;
}
