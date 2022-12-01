import 'package:flutter/material.dart';

class MemoTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function textChange;

  const MemoTextField({
    Key? key,
    required this.controller,
    required this.textChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'メモ',
          border: InputBorder.none,
        ),
        onChanged: (text) {
          textChange(text);
        },
      ),
      leading: const Icon(Icons.featured_play_list_rounded),
    );
  }
}
