import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class NoDataCaseImg extends StatelessWidget {
  final String text;
  final double height;

  const NoDataCaseImg({
    required this.text,
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height),
        SizedBox(
          width: 100,
          child: Image.asset('assets/image/app_theme_gray.png'),
        ),
        Text('$textが存在しません', style: const TextStyle(fontWeight: FontWeight.bold,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('「', style: TextStyle(color: CustomColor.detailTextColor),),
            const Icon(Icons.edit, size: 16, color: CustomColor.detailTextColor,),
            Text('入力」から$textを追加してください', style: const TextStyle(color: CustomColor.detailTextColor),),
          ],
        ),
      ],
    );
  }
}
