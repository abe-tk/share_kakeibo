import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final Color? textColor;
  final Color? buttonColor;
  final VoidCallback onTaped;

  const CustomElevatedButton({
    Key? key,
    this.text = '',
    this.textColor = Colors.black,
    this.buttonColor = Colors.white,
    required this.onTaped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTaped,
      child: Text(
        '$text',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
