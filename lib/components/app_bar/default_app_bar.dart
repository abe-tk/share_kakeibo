import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const DefaultAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      elevation: 1,
      backgroundColor: appBarBackGroundColor,
    );
  }
}
