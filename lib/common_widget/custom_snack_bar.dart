import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// SnackBar表示のためののGlobalKey
// 無理にProviderにする必要はないかも？
final scaffoldKeyProvider = Provider(
  (ref) => GlobalKey<ScaffoldMessengerState>(),
);

class CustomSnackBar extends SnackBar {
  CustomSnackBar(
    BuildContext context, {
    super.key,
    required String msg,
    Color? color,
  }) : super(
          elevation: 0,
          backgroundColor: color ?? Colors.black87,
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
        );
}
