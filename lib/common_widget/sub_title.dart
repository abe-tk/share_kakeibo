import 'package:flutter/material.dart';

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
            color: Colors.grey,
          ),
        ),
        const Divider(
          color: Colors.grey,
        ),
      ],
    );
  }
}
