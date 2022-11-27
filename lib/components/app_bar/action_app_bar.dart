import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class ActionAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Function function;

 const  ActionAppBar({
    Key? key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.function,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        AppIconButton(
          icon: icon,
          color: iconColor,
          function: () {
            function();
          },
        ),
      ],
      centerTitle: true,
      elevation: title == '' ? 0 : 1,
      backgroundColor: appBarBackGroundColor,
    );
  }
}
