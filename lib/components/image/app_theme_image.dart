import 'package:flutter/material.dart';

class AppThemeImage extends StatelessWidget {
  const AppThemeImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Image(
      image: AssetImage('assets/image/app_theme.png'),
      height: 160,
      width: 160,
    );
  }
}
