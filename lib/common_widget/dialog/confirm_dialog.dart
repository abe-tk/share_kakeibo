import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:share_kakeibo/extension/text_theme.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog._({
    required this.title,
    this.message,
    required this.showCancelButton,
    required this.showConfirmButton,
    this.cancelButtonText,
    this.confirmButtonText,
    this.confirmButtonTextStyle,
  });

  final String title;
  final String? message;
  final bool showCancelButton;
  final bool showConfirmButton;
  final String? cancelButtonText;
  final String? confirmButtonText;
  final TextStyle? confirmButtonTextStyle;

  static Future<bool> show({
    required BuildContext context,
    required String title,
    String? message,
    bool showCancelButton = true,
    bool showConfirmButton = true,
    String? cancelButtonText,
    String? confirmButtonText,
    TextStyle? confirmButtonTextStyle,
  }) async {
    final result = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => ConfirmDialog._(
        title: title,
        message: message,
        showCancelButton: showCancelButton,
        showConfirmButton: showConfirmButton,
        cancelButtonText: cancelButtonText,
        confirmButtonText: confirmButtonText,
        confirmButtonTextStyle: confirmButtonTextStyle,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (message != null) ...[
            Text(message!),
            const Gap(16),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showCancelButton) ...[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    cancelButtonText ?? "キャンセル",
                    style: context.bodyMediumGrey,
                  ),
                ),
                const Gap(8),
              ],
              if (showConfirmButton)
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    confirmButtonText ?? "OK",
                    style: confirmButtonTextStyle ?? context.bodyMediumBold,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
