import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class NoDataCase extends StatelessWidget {
  final String text;

  const NoDataCase({
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        SizedBox(
          width: 100,
          child: Image.asset('assets/image/app_theme_gray.png'),
        ),
        Text('$textが存在しません', style: const TextStyle(fontWeight: FontWeight.bold,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('「', style: TextStyle(color: detailTextColor),),
            Icon(Icons.edit, size: 16, color: detailTextColor,),
            Text('入力」から$textを追加してください', style: TextStyle(color: detailTextColor),),
          ],
        ),
      ],
    );
  }
}
