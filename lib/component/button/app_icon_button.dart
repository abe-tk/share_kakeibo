import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Function function;

  const AppIconButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color,),
      onPressed: () {
        function();
      },
    );
  }
}
