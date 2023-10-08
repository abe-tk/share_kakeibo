import 'package:flutter/material.dart';
import 'package:share_kakeibo/importer.dart';

class SubTitle extends StatelessWidget {
  final String title;

  const SubTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: CustomColor.detailTextColor,
          ),
        ),
        const Divider(
          color: CustomColor.detailTextColor,
        ),
      ],
    );
  }
}
