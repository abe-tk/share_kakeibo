// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

DateTime currentYear = DateTime(DateTime.now().year);

final currentYearProvider =
StateNotifierProvider<CurrentYearNotifier, DateTime>((ref) {
  return CurrentYearNotifier();
});

class CurrentYearNotifier extends StateNotifier<DateTime> {
  CurrentYearNotifier() : super(currentYear);

  Future<void> oneYearAgo() async {
    currentYear = DateTime(state.year - 1);
    state = currentYear;
  }

  Future<void> oneYearLater() async {
    currentYear = DateTime(state.year + 1);
    state = currentYear;
  }

}