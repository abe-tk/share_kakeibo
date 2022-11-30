import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class MemoList extends StatelessWidget {
  final bool completed;
  final String memo;
  final DateTime date;
  final Function function;

  const MemoList({
    required this.completed,
    required this.memo,
    required this.date,
    required this.function,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: CheckboxListTile(
            controlAffinity: ListTileControlAffinity.leading,
            checkColor: checkboxChekColor,
            activeColor: checkboxActiveColor,
            value: completed,
            onChanged: (value) {
              function(value);
            },
            title: Text(
              memo,
              style: TextStyle(
                decoration: (completed == true)
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(DateFormat.MMMEd('ja').format(date)),
          ),
        ),
      ),
    );
  }
}
