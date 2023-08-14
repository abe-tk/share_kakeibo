import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class MemoBatch extends StatelessWidget {
  final bool isNotEmpty;
  final int length;

  const MemoBatch({
    Key? key,
    required this.isNotEmpty,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(Icons.featured_play_list_outlined),
        Visibility(
          visible: isNotEmpty ? true : false,
          child: Positioned(
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: const BoxDecoration(
                color: CustomColor.biBackGroundColor,
                shape: BoxShape.circle,
              ),
              width: 16.0,
              height: 16.0,
              child: Center(
                child: Text(
                  '$length',
                  style: const TextStyle().copyWith(
                    color: CustomColor.biTextColor,
                    fontSize: 12.0,
                  ),
                ),
              ),
              constraints: const BoxConstraints(
                minHeight: 12,
                minWidth: 12,
              ),
              alignment: Alignment.center,
            ),
          ),
        ),
      ],
    );
  }
}
