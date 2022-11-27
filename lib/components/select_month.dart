import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class SelectMonth extends StatelessWidget {
  final DateTime month;
  final Function left;
  final Function center;
  final Function right;

  const SelectMonth({
    Key? key,
    required this.month,
    required this.left,
    required this.center,
    required this.right,
  }) : super(key: key);

  DateTime oneMonthAgo (DateTime date) {
    date = DateTime(date.year, date.month - 1);
    return date;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppIconButton(
          icon: Icons.chevron_left,
          color: detailIconColor,
          function: () => left(),
        ),
        TextButton(
          child: Text(
            DateFormat.yMMM('ja').format(month),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: normalTextColor
            ),
          ),
          onPressed: () => center(),
        ),
        AppIconButton(
          icon: Icons.chevron_right,
          color: detailIconColor,
          function: () => right(),
        ),
      ],
    );
  }
}
