// constant
import 'package:share_kakeibo/constant/colors.dart';
// view_model
import 'package:share_kakeibo/view_model/setting/personal_setting/email_view_model.dart';
import 'package:share_kakeibo/view_model/setting/personal_setting/widgets/password_dialog_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChangeEmailPasswordDialog extends HookConsumerWidget {
  const ChangeEmailPasswordDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailViewModelNotifier = ref.watch(emailViewModelProvider.notifier);
    final passwordDialogViewModelNotifier = ref.watch(passwordDialogViewModelProvider.notifier);
    final _isObscure = useState(true);
    return SimpleDialog(
      title: const Text("パスワードを入力"),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: ListTile(
            title: TextFormField(
              controller: passwordDialogViewModelNotifier.passwordController,
              obscureText: _isObscure.value,
              decoration: InputDecoration(
                hintText: 'パスワード',
                suffixIcon: IconButton(
                  icon: Icon(_isObscure.value
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    _isObscure.value = !_isObscure.value;
                  },
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.transparent,
                  ),
                ),
              ),
              onChanged: (text) {
                passwordDialogViewModelNotifier.setPassword(text);
              },
              maxLength: 20,
            ),
            // leading: const Icon(Icons.note),
          ),
        ),
        Row(
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("CANCEL"),
            ),
            SimpleDialogOption(
              onPressed: () async {
                try {
                  await passwordDialogViewModelNotifier.reSignIn();
                  await emailViewModelNotifier.updateEmail();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: positiveSnackBarColor,
                      behavior: SnackBarBehavior.floating,
                      content: const Text('メールアドレスを変更しました'),
                    ),
                  );
                } catch (e) {
                  final snackBar = SnackBar(
                    backgroundColor: negativeSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar);
                }
              },
              child: const Text("OK"),
            ),
          ],
        ),
      ],
    );
  }
}
