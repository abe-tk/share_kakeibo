import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class LoginTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool suffix;
  final bool obscure;
  final String text;
  final Function obscureChange;
  final Function textChange;

  const LoginTextField({
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
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: textFieldBorderSideColor,
              width: 2.0,
            ),
          ),
          labelStyle: TextStyle(
            fontSize: 12,
            color: textFieldTextColor,
          ),
          labelText: text,
          suffixIcon: suffix == true
              ? IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    obscureChange();
                  },
                )
              : null,
          floatingLabelStyle: const TextStyle(fontSize: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: textFieldBorderSideColor,
              width: 1.0,
            ),
          ),
        ),
        onChanged: (text) {
          textChange(text);
        },
      ),
    );
  }
}
