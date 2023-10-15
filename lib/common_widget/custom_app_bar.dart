import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTaped;

  const CustomAppBar({
    Key? key,
    this.title = '',
    this.icon,
    this.iconColor,
    this.onTaped,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('$title'),
      actions: [
        if (icon != null)
          IconButton(
            icon: Icon(
              icon,
              color: iconColor,
            ),
            onPressed: onTaped,
          ),
      ],
      elevation: 0,
    );
  }
}
