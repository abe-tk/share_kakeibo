import 'package:flutter/material.dart';
import 'package:share_kakeibo/constant/colors.dart';

void appSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void positiveSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    backgroundColor: positiveSnackBarColor,
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void negativeSnackBar(BuildContext context, String msg) {
  final snackBar = SnackBar(
    backgroundColor: negativeSnackBarColor,
    behavior: SnackBarBehavior.floating,
    content: Text(msg),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
