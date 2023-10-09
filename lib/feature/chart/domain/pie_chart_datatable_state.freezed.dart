// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pie_chart_datatable_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PieChartDatatableState {
  /// 合計金額
  int get totalPrice => throw _privateConstructorUsedError;

  /// 本体
  List<PieChartSourceData> get pieChartSourceData =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PieChartDatatableStateCopyWith<PieChartDatatableState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PieChartDatatableStateCopyWith<$Res> {
  factory $PieChartDatatableStateCopyWith(PieChartDatatableState value,
          $Res Function(PieChartDatatableState) then) =
      _$PieChartDatatableStateCopyWithImpl<$Res, PieChartDatatableState>;
  @useResult
  $Res call({int totalPrice, List<PieChartSourceData> pieChartSourceData});
}

/// @nodoc
class _$PieChartDatatableStateCopyWithImpl<$Res,
        $Val extends PieChartDatatableState>
    implements $PieChartDatatableStateCopyWith<$Res> {
  _$PieChartDatatableStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPrice = null,
    Object? pieChartSourceData = null,
  }) {
    return _then(_value.copyWith(
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      pieChartSourceData: null == pieChartSourceData
          ? _value.pieChartSourceData
          : pieChartSourceData // ignore: cast_nullable_to_non_nullable
              as List<PieChartSourceData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PieChartDatatableStateCopyWith<$Res>
    implements $PieChartDatatableStateCopyWith<$Res> {
  factory _$$_PieChartDatatableStateCopyWith(_$_PieChartDatatableState value,
          $Res Function(_$_PieChartDatatableState) then) =
      __$$_PieChartDatatableStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int totalPrice, List<PieChartSourceData> pieChartSourceData});
}

/// @nodoc
class __$$_PieChartDatatableStateCopyWithImpl<$Res>
    extends _$PieChartDatatableStateCopyWithImpl<$Res,
        _$_PieChartDatatableState>
    implements _$$_PieChartDatatableStateCopyWith<$Res> {
  __$$_PieChartDatatableStateCopyWithImpl(_$_PieChartDatatableState _value,
      $Res Function(_$_PieChartDatatableState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalPrice = null,
    Object? pieChartSourceData = null,
  }) {
    return _then(_$_PieChartDatatableState(
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      pieChartSourceData: null == pieChartSourceData
          ? _value._pieChartSourceData
          : pieChartSourceData // ignore: cast_nullable_to_non_nullable
              as List<PieChartSourceData>,
    ));
  }
}

/// @nodoc

class _$_PieChartDatatableState implements _PieChartDatatableState {
  const _$_PieChartDatatableState(
      {this.totalPrice = 0,
      final List<PieChartSourceData> pieChartSourceData =
          const <PieChartSourceData>[]})
      : _pieChartSourceData = pieChartSourceData;

  /// 合計金額
  @override
  @JsonKey()
  final int totalPrice;

  /// 本体
  final List<PieChartSourceData> _pieChartSourceData;

  /// 本体
  @override
  @JsonKey()
  List<PieChartSourceData> get pieChartSourceData {
    if (_pieChartSourceData is EqualUnmodifiableListView)
      return _pieChartSourceData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pieChartSourceData);
  }

  @override
  String toString() {
    return 'PieChartDatatableState(totalPrice: $totalPrice, pieChartSourceData: $pieChartSourceData)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PieChartDatatableState &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            const DeepCollectionEquality()
                .equals(other._pieChartSourceData, _pieChartSourceData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalPrice,
      const DeepCollectionEquality().hash(_pieChartSourceData));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PieChartDatatableStateCopyWith<_$_PieChartDatatableState> get copyWith =>
      __$$_PieChartDatatableStateCopyWithImpl<_$_PieChartDatatableState>(
          this, _$identity);
}

abstract class _PieChartDatatableState implements PieChartDatatableState {
  const factory _PieChartDatatableState(
          {final int totalPrice,
          final List<PieChartSourceData> pieChartSourceData}) =
      _$_PieChartDatatableState;

  @override

  /// 合計金額
  int get totalPrice;
  @override

  /// 本体
  List<PieChartSourceData> get pieChartSourceData;
  @override
  @JsonKey(ignore: true)
  _$$_PieChartDatatableStateCopyWith<_$_PieChartDatatableState> get copyWith =>
      throw _privateConstructorUsedError;
}
