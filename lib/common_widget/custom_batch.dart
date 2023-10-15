import 'package:flutter/material.dart';

class CustomBatch extends StatelessWidget {
  final int length;

  const CustomBatch({
    Key? key,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: length != 0,
      child: Positioned(
        right: 0,
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          width: 16.0,
          height: 16.0,
          child: Text(
            length < 100 ? '$length' : '99',
            style: const TextStyle().copyWith(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
