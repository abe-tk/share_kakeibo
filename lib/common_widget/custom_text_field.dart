import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function textChange;
  final bool? isObscure;
  final VoidCallback? isObscureChange;
  
  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.textChange,
    this.isObscure,
    this.isObscureChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        textAlign: TextAlign.left,
        controller: controller,
        obscureText: isObscure ?? false,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          border: InputBorder.none,
          suffixIcon: isObscure != null
              ? IconButton(
                  icon: Icon(
                    isObscure ?? false
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: isObscureChange,
                )
              : null,
        ),
        onChanged: (text) => textChange(text),
      ),
    );
  }
}
