import 'package:flutter/material.dart';
import 'package:share_kakeibo/constant/colors.dart';

class LoginElevatedButton extends StatelessWidget {
  final String text;
  final Function function;

  const LoginElevatedButton({
    Key? key,
    required this.text,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: () {
          function();
        },
        child: Text(text),
        style: ElevatedButton.styleFrom(
          primary: elevatedButtonColor,
          side: BorderSide(
            color: elevatedButtonBorderSideColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}
