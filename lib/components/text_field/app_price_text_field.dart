import 'package:flutter/material.dart';

class AppPriceTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function textChange;

  const AppPriceTextField({
    Key? key,
    required this.controller,
    required this.textChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 100,
      child: ListTile(
        title: TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          controller: controller,
          decoration: const InputDecoration(
            hintText: '0',
            border: InputBorder.none,
          ),
          onChanged: (text) {
            textChange(text);
          },
        ),
        leading: const Icon(Icons.currency_yen),
        trailing: const Text('円'),
      ),
    );
  }
}
