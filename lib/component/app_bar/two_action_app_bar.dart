import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class TwoActionAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconData firstIcon;
  final Color firstIconColor;
  final Function firstFunction;
  final IconData secondIcon;
  final Color secondIconColor;
  final Function secondFunction;

  const  TwoActionAppBar({
    Key? key,
    required this.title,
    required this.firstIcon,
    required this.firstIconColor,
    required this.firstFunction,
    required this.secondIcon,
    required this.secondIconColor,
    required this.secondFunction,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        AppIconButton(
          icon: firstIcon,
          color: firstIconColor,
          function: () {
            firstFunction();
          },
        ),
        AppIconButton(
          icon: secondIcon,
          color: secondIconColor,
          function: () {
            secondFunction();
          },
        ),
      ],
      elevation: 1,
    );
  }
}
