import 'package:flutter/material.dart';

/* 
ダイアログを表示
showProgressDialog(context);

ダイアログを閉じる
Navigator.of(context).pop();
*/

void showProgressDialog(context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: Duration.zero,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (BuildContext context, Animation animation,
        Animation secondaryAnimation) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}
