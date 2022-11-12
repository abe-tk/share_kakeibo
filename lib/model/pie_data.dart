import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'pie_data.freezed.dart';

@freezed
class PieData with _$PieData {
  const factory PieData({
    required String title,
    required double percent,
    required Color color,
  }) = _PieData;
}