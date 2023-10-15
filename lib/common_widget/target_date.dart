import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TargetDate extends StatelessWidget {
  final DateTime? year;
  final DateTime? month;
  final VoidCallback? onTapedDate;
  final VoidCallback onTapedLeft;
  final VoidCallback onTapedRight;

  const TargetDate({
    Key? key,
    this.year,
    this.month,
    this.onTapedDate,
    required this.onTapedLeft,
    required this.onTapedRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
          onPressed: onTapedLeft,
        ),
        year != null
            ? Text(
                DateFormat.y('ja').format(year!),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
            : TextButton(
                child: Text(
                  DateFormat.yMMM('ja').format(month!),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                onPressed: onTapedDate,
              ),
        IconButton(
          icon: const Icon(
            Icons.chevron_right,
            color: Colors.black,
          ),
          onPressed: onTapedRight,
        ),
      ],
    );
  }
}
