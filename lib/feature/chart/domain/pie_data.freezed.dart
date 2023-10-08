// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
      _$PieDataCopyWithImpl<$Res, PieData>;
  @useResult
  $Res call({String title, double percent, Color color});
}

/// @nodoc
class _$PieDataCopyWithImpl<$Res, $Val extends PieData>
    implements $PieDataCopyWith<$Res> {
  _$PieDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? percent = null,
    Object? color = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as Color,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PieDataCopyWith<$Res> implements $PieDataCopyWith<$Res> {
  factory _$$_PieDataCopyWith(
          _$_PieData value, $Res Function(_$_PieData) then) =
      __$$_PieDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, double percent, Color color});
}

/// @nodoc
class __$$_PieDataCopyWithImpl<$Res>
    extends _$PieDataCopyWithImpl<$Res, _$_PieData>
    implements _$$_PieDataCopyWith<$Res> {
  __$$_PieDataCopyWithImpl(_$_PieData _value, $Res Function(_$_PieData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? percent = null,
    Object? color = null,
  }) {
    return _then(_$_PieData(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      percent: null == percent
          ? _value.percent
          : percent // ignore: cast_nullable_to_non_nullable
              as double,
      color: null == color
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
            (identical(other.title, title) || other.title == title) &&
            (identical(other.percent, percent) || other.percent == percent) &&
            (identical(other.color, color) || other.color == color));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, percent, color);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
