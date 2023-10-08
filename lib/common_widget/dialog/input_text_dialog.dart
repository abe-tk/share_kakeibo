import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/importer.dart';

class InputTextDialog extends HookConsumerWidget {
  const InputTextDialog._({
    required this.title,
    this.message,
    this.hintText,
    required this.isPassword,
    required this.showCancelButton,
    required this.showConfirmButton,
    this.cancelButtonText,
    this.confirmButtonText,
    this.confirmButtonTextStyle,
  });

  final String title;
  final String? message;
  final String? hintText;
  final bool isPassword;
  final bool showCancelButton;
  final bool showConfirmButton;
  final String? cancelButtonText;
  final String? confirmButtonText;
  final TextStyle? confirmButtonTextStyle;

  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? message,
    String? hintText,
    bool isPassword = false,
    bool showCancelButton = true,
    bool showConfirmButton = true,
    String? cancelButtonText,
    String? confirmButtonText,
    TextStyle? confirmButtonTextStyle,
  }) async {
    final result = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => InputTextDialog._(
        title: title,
        message: message,
        hintText: hintText,
        isPassword: isPassword,
        showCancelButton: showCancelButton,
        showConfirmButton: showConfirmButton,
        cancelButtonText: cancelButtonText,
        confirmButtonText: confirmButtonText,
        confirmButtonTextStyle: confirmButtonTextStyle,
      ),
    );
    return result;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isObscure = useState(true);
    final inputText = useState('');
    final inputTextController = useTextEditingController();

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
          !isPassword
              ? TextFormField(
                  controller: inputTextController,
                  decoration: InputDecoration(
                    hintText: hintText,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  onChanged: (text) => inputText.value = text,
                )
              : TextFormField(
                  controller: inputTextController,
                  obscureText: isObscure.value,
                  decoration: InputDecoration(
                    hintText: hintText,
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        isObscure.value = !isObscure.value;
                      },
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                  onChanged: (text) => inputText.value = text,
                ),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (showCancelButton) ...[
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text(
                    cancelButtonText ?? "キャンセル",
                    style: context.bodyMediumGrey,
                  ),
                ),
                const Gap(8),
              ],
              if (showConfirmButton)
                TextButton(
                  onPressed: () => Navigator.pop(context, inputText.value),
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
