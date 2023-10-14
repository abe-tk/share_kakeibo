import 'package:flutter/material.dart';
import 'package:share_kakeibo/importer.dart';

class LoginTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final Function(String) textChange;
  final bool? isObscure;
  final VoidCallback? isObscureChange;

  const LoginTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    required this.textChange,
    this.isObscure,
    this.isObscureChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure ?? false,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: CustomColor.tfBorderSideColor,
            width: 2.0,
          ),
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          color: CustomColor.tfBorderSideColor,
        ),
        labelText: labelText,
        suffixIcon: isObscure != null
            ? IconButton(
                icon: Icon(
                  isObscure ?? false ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: isObscureChange,
              )
            : null,
        floatingLabelStyle: const TextStyle(fontSize: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: CustomColor.tfBorderSideColor,
            width: 1.0,
          ),
        ),
      ),
      onChanged: (text) => textChange(text),
    );
  }
}
