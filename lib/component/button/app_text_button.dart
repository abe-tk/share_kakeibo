import 'package:flutter/material.dart';

class AppTextButton extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final Function function;

  const AppTextButton({
    Key? key,
    required this.text,
    required this.size,
    required this.color,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          color: color,
        ),
      ),
      onPressed: () {
        function();
      },
    );
  }
}
