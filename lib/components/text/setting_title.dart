import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class SettingTitle extends StatelessWidget {
  final String title;

  const SettingTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.all(16),
          child: Text(
            title,
            style: TextStyle(
              color: detailTextColor,
            ),
          ),
        ),
        Divider(
          height: 0,
          thickness: 1,
          indent: 16,
          endIndent: 16,
          color: dividerColor,
        ),
      ],
    );
  }
}
