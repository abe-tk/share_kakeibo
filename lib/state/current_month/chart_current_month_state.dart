// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

DateTime chartCurrentMonth = DateTime(DateTime.now().year, DateTime.now().month);

final chartCurrentMonthProvider =
StateNotifierProvider<ChartCurrentMonthNotifier, DateTime>((ref) {
  return ChartCurrentMonthNotifier();
});

class ChartCurrentMonthNotifier extends StateNotifier<DateTime> {
  ChartCurrentMonthNotifier() : super(chartCurrentMonth);

  Future<void> oneMonthAgo() async {
    chartCurrentMonth = DateTime(state.year, state.month - 1);
    state = chartCurrentMonth;
  }

  Future<void> oneMonthLater() async {
    chartCurrentMonth = DateTime(state.year, state.month + 1);
    state = DateTime(state.year, state.month + 1);
  }

  Future<void> selectMonth(BuildContext context) async {
    var selectedMonth = await showMonthPicker(
      context: context,
      initialDate: state,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (selectedMonth == null) {
      return;
    } else {
      chartCurrentMonth = selectedMonth;
      state = selectedMonth;
    }
  }

}