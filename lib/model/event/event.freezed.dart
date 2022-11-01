// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Event {
  String get id => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String get price => throw _privateConstructorUsedError;
  String get largeCategory => throw _privateConstructorUsedError;
  String get smallCategory => throw _privateConstructorUsedError;
  String get memo => throw _privateConstructorUsedError;
  String get paymentUser => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EventCopyWith<Event> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EventCopyWith<$Res> {
  factory $EventCopyWith(Event value, $Res Function(Event) then) =
      _$EventCopyWithImpl<$Res>;
  $Res call(
      {String id,
      DateTime date,
      String price,
      String largeCategory,
      String smallCategory,
      String memo,
      String paymentUser});
}

/// @nodoc
class _$EventCopyWithImpl<$Res> implements $EventCopyWith<$Res> {
  _$EventCopyWithImpl(this._value, this._then);

  final Event _value;
  // ignore: unused_field
  final $Res Function(Event) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? date = freezed,
    Object? price = freezed,
    Object? largeCategory = freezed,
    Object? smallCategory = freezed,
    Object? memo = freezed,
    Object? paymentUser = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      largeCategory: largeCategory == freezed
          ? _value.largeCategory
          : largeCategory // ignore: cast_nullable_to_non_nullable
              as String,
      smallCategory: smallCategory == freezed
          ? _value.smallCategory
          : smallCategory // ignore: cast_nullable_to_non_nullable
              as String,
      memo: memo == freezed
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      paymentUser: paymentUser == freezed
          ? _value.paymentUser
          : paymentUser // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_EventCopyWith<$Res> implements $EventCopyWith<$Res> {
  factory _$$_EventCopyWith(_$_Event value, $Res Function(_$_Event) then) =
      __$$_EventCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      DateTime date,
      String price,
      String largeCategory,
      String smallCategory,
      String memo,
      String paymentUser});
}

/// @nodoc
class __$$_EventCopyWithImpl<$Res> extends _$EventCopyWithImpl<$Res>
    implements _$$_EventCopyWith<$Res> {
  __$$_EventCopyWithImpl(_$_Event _value, $Res Function(_$_Event) _then)
      : super(_value, (v) => _then(v as _$_Event));

  @override
  _$_Event get _value => super._value as _$_Event;

  @override
  $Res call({
    Object? id = freezed,
    Object? date = freezed,
    Object? price = freezed,
    Object? largeCategory = freezed,
    Object? smallCategory = freezed,
    Object? memo = freezed,
    Object? paymentUser = freezed,
  }) {
    return _then(_$_Event(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: date == freezed
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      price: price == freezed
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as String,
      largeCategory: largeCategory == freezed
          ? _value.largeCategory
          : largeCategory // ignore: cast_nullable_to_non_nullable
              as String,
      smallCategory: smallCategory == freezed
          ? _value.smallCategory
          : smallCategory // ignore: cast_nullable_to_non_nullable
              as String,
      memo: memo == freezed
          ? _value.memo
          : memo // ignore: cast_nullable_to_non_nullable
              as String,
      paymentUser: paymentUser == freezed
          ? _value.paymentUser
          : paymentUser // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$_Event implements _Event {
  const _$_Event(
      {required this.id,
      required this.date,
      required this.price,
      required this.largeCategory,
      required this.smallCategory,
      required this.memo,
      required this.paymentUser});

  @override
  final String id;
  @override
  final DateTime date;
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
    return 'Event(id: $id, date: $date, price: $price, largeCategory: $largeCategory, smallCategory: $smallCategory, memo: $memo, paymentUser: $paymentUser)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Event &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.date, date) &&
            const DeepCollectionEquality().equals(other.price, price) &&
            const DeepCollectionEquality()
                .equals(other.largeCategory, largeCategory) &&
            const DeepCollectionEquality()
                .equals(other.smallCategory, smallCategory) &&
            const DeepCollectionEquality().equals(other.memo, memo) &&
            const DeepCollectionEquality()
                .equals(other.paymentUser, paymentUser));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(date),
      const DeepCollectionEquality().hash(price),
      const DeepCollectionEquality().hash(largeCategory),
      const DeepCollectionEquality().hash(smallCategory),
      const DeepCollectionEquality().hash(memo),
      const DeepCollectionEquality().hash(paymentUser));

  @JsonKey(ignore: true)
  @override
  _$$_EventCopyWith<_$_Event> get copyWith =>
      __$$_EventCopyWithImpl<_$_Event>(this, _$identity);
}

abstract class _Event implements Event {
  const factory _Event(
      {required final String id,
      required final DateTime date,
      required final String price,
      required final String largeCategory,
      required final String smallCategory,
      required final String memo,
      required final String paymentUser}) = _$_Event;

  @override
  String get id;
  @override
  DateTime get date;
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
