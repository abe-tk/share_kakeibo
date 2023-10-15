import 'package:flutter/material.dart';

class UpsertEventTextField extends StatelessWidget {
  final Icon icon;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool autofocus;
  final Function(String)? textChange;

  const UpsertEventTextField({
    Key? key,
    required this.icon,
    this.hintText = '',
    this.controller,
    this.keyboardType = TextInputType.text,
    this.autofocus = false,
    this.textChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: icon,
          ),
          Expanded(
            child: TextField(
              autofocus: autofocus,
              keyboardType: keyboardType,
              controller: controller,
              decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                fillColor: Colors.white,
                filled: true,
              ),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onChanged: textChange,
            ),
          ),
        ],
      ),
    );
  }
}
