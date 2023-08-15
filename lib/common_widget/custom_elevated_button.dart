import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String? text;
  final VoidCallback onTaped;

  const CustomElevatedButton({
    Key? key,
    this.text = '',
    required this.onTaped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.8,
      child: ElevatedButton(
        onPressed: onTaped,
        child: Text('$text'),
      ),
    );
  }
}
