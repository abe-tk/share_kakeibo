import 'package:share_kakeibo/feature/chart/domain/pie_chart_source_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pie_chart_datatable_state.freezed.dart';

@freezed
class PieChartDatatableState with _$PieChartDatatableState {
  const factory PieChartDatatableState({
    /// 合計金額
    @Default(0) int totalPrice,

    /// 本体
    @Default(<PieChartSourceData>[]) List<PieChartSourceData> pieChartSourceData,
  }) = _PieChartDatatableState;
}