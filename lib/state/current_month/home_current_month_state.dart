// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

DateTime homeCurrentMonth = DateTime(DateTime.now().year, DateTime.now().month);

final homeCurrentMonthProvider =
StateNotifierProvider<HomeCurrentMonthNotifier, DateTime>((ref) {
  return HomeCurrentMonthNotifier();
});

class HomeCurrentMonthNotifier extends StateNotifier<DateTime> {
  HomeCurrentMonthNotifier() : super(homeCurrentMonth);

  Future<void> oneMonthAgo() async {
    homeCurrentMonth = DateTime(state.year, state.month - 1);
    state = homeCurrentMonth;
  }

  Future<void> oneMonthLater() async {
    homeCurrentMonth = DateTime(state.year, state.month + 1);
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
      homeCurrentMonth = selectedMonth;
      state = selectedMonth;
    }
  }

}