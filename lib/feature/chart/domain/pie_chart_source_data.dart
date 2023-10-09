import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pie_chart_source_data.freezed.dart';

@freezed
class PieChartSourceData with _$PieChartSourceData {
  const factory PieChartSourceData({
    required String category,
    required IconData? icon,
    required String? imgURL,
    required Color color,
    required int price,
    required double percent,
  }) = _PieChartSourceData;
}
