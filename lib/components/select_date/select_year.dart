import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class SelectYear extends StatelessWidget {
  final DateTime year;
  final Function left;
  final Function right;

  const SelectYear({
    Key? key,
    required this.year,
    required this.left,
    required this.right,
  }) : super(key: key);

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
        Text(
          DateFormat.y('ja').format(year),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
