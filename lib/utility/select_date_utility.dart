import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

// 月日の選択
Future<DateTime> selectDate(BuildContext context, DateTime date) async {
  final DateTime? selected = await showDatePicker(
    context: context,
    initialDate: date,
    firstDate: DateTime(2015),
    lastDate: DateTime(2035),
  );
  if (selected == null) {
    return date;
  } else {
    return selected;
  }
}

// 月の選択
Future<DateTime> selectMonth(BuildContext context, DateTime date) async {
  var selectedMonth = await showMonthPicker(
    context: context,
    initialDate: date,
    firstDate: DateTime(DateTime.now().year - 1),
    lastDate: DateTime(DateTime.now().year + 1),
  );
  if (selectedMonth == null) {
    return date;
  } else {
    return selectedMonth;
  }
}
