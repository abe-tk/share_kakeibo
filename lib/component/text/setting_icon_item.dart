import 'package:flutter/material.dart';

class SettingIconItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function function;

  const SettingIconItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        function();
      },
    );
  }
}
