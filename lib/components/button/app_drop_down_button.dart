import 'package:flutter/material.dart';

class AppDropDownButton extends StatelessWidget {
  final String value;
  final Function function;
  final List<String> item;
  final Icon icon;

  const AppDropDownButton({
    Key? key,
    required this.value,
    required this.function,
    required this.item,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: DropdownButton<String>(
        value: value,
        onChanged: (String? value) {
          function(value);
        },
        items: item
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
      leading: icon,
    );
  }
}