// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'pie_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PieData {
  String get title => throw _privateConstructorUsedError;
  double get percent => throw _privateConstructorUsedError;
  Color get color => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PieDataCopyWith<PieData> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PieDataCopyWith<$Res> {
  factory $PieDataCopyWith(PieData value, $Res Function(PieData) then) =
      _$PieDataCopyWithImpl<$Res>;
  $Res call({String title, double percent, Color color});
}

/// @nodoc
class _$PieDataCopyWithImpl<$Res> implements $PieDataCopyWith<$Res> {
  _$PieDataCopyWithImpl(this._value, this._then);

  final PieData _value;
  // ignore: unused_field
  final $Res Function(PieData) _then;

  @override
  $Res call({
    Object? title = freezed,
    Object? percent = freezed,
    Object? color = freezed,
  }) {
    return _then(_value.copyWith(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      percent: percent == freezed
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc
abstract class _$$_PieDataCopyWith<$Res> implements $PieDataCopyWith<$Res> {
  factory _$$_PieDataCopyWith(
          _$_PieData value, $Res Function(_$_PieData) then) =
      __$$_PieDataCopyWithImpl<$Res>;
  @override
  $Res call({String title, double percent, Color color});
}

/// @nodoc
class __$$_PieDataCopyWithImpl<$Res> extends _$PieDataCopyWithImpl<$Res>
    implements _$$_PieDataCopyWith<$Res> {
  __$$_PieDataCopyWithImpl(_$_PieData _value, $Res Function(_$_PieData) _then)
      : super(_value, (v) => _then(v as _$_PieData));

  @override
  _$_PieData get _value => super._value as _$_PieData;

  @override
  $Res call({
    Object? title = freezed,
    Object? percent = freezed,
    Object? color = freezed,
  }) {
    return _then(_$_PieData(
      title: title == freezed
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      percent: percent == freezed
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      color: color == freezed
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ));
  }
}

/// @nodoc

class _$_PieData implements _PieData {
  const _$_PieData(
      {required this.title, required this.percent, required this.color});

  @override
  final String title;
  @override
  final double percent;
  @override
  final Color color;

  @override
  String toString() {
    return 'PieData(title: $title, percent: $percent, color: $color)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PieData &&
            const DeepCollectionEquality().equals(other.title, title) &&
            const DeepCollectionEquality().equals(other.percent, percent) &&
            const DeepCollectionEquality().equals(other.color, color));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(title),
      const DeepCollectionEquality().hash(percent),
      const DeepCollectionEquality().hash(color));

  @JsonKey(ignore: true)
  @override
  _$$_PieDataCopyWith<_$_PieData> get copyWith =>
      __$$_PieDataCopyWithImpl<_$_PieData>(this, _$identity);
}

abstract class _PieData implements PieData {
  const factory _PieData(
      {required final String title,
      required final double percent,
      required final Color color}) = _$_PieData;

  @override
  String get title;
  @override
  double get percent;
  @override
  Color get color;
  @override
  @JsonKey(ignore: true)
  _$$_PieDataCopyWith<_$_PieData> get copyWith =>
      throw _privateConstructorUsedError;
}
