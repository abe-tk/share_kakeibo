import 'package:flutter/material.dart';
import 'package:share_kakeibo/constant/colors.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final Function function;

  const AppTextButton({
    Key? key,
    required this.text,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text,
        style: TextStyle(
          fontSize: 20,
          color: normalTextColor,
        ),
      ),
      onPressed: () {
        function();
      },
    );
  }
}
