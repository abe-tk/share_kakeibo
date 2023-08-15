import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Function function;

  const SettingItem({
    Key? key,
    required this.title,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        function();
      },
    );
  }
}
