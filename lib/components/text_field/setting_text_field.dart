import 'package:flutter/material.dart';

class SettingTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool suffix;
  final bool obscure;
  final String text;
  final Function obscureChange;
  final Function textChange;

  const SettingTextField({
    Key? key,
    required this.controller,
    required this.suffix,
    required this.obscure,
    required this.text,
    required this.obscureChange,
    required this.textChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: ListTile(
        title: TextField(
          textAlign: TextAlign.left,
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: text,
            border: InputBorder.none,
            suffixIcon: suffix == true
                ? IconButton(
                    icon:
                        Icon(obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      obscureChange();
                    },
                  )
                : null,
          ),
          onChanged: (text) {
            textChange(text);
          },
        ),
      ),
    );
  }
}
