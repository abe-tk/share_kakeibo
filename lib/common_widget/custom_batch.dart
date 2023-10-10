import 'package:flutter/material.dart';
import 'package:share_kakeibo/importer.dart';

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
            color: CustomColor.biBackGroundColor,
            shape: BoxShape.circle,
          ),
          width: 16.0,
          height: 16.0,
          child: Text(
            length < 100 ? '$length' : '99',
            style: const TextStyle().copyWith(
              color: CustomColor.biTextColor,
              fontSize: 12.0,
            ),
          ),
        ),
      ),
    );
  }
}
