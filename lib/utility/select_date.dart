import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

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