import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final Function function;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.subTitle,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Visibility(
        visible: subTitle != '',
        child: Text(subTitle),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            function();
          },
        ),
      ],
    );
  }
}
