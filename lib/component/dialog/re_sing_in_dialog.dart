import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class ReSingInDialog extends HookConsumerWidget {
  final Function function;
  final Function navigator;
  final String text;

  const ReSingInDialog({
    Key? key,
    required this.function,
    required this.navigator,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isObscure = useState(true);
    final password = useState('');
    final passwordController = useState(TextEditingController());
    return SimpleDialog(
      title: const Text("パスワードを入力"),
      children: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: ListTile(
            title: TextFormField(
              controller: passwordController.value,
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
                password.value = text;
              },
              maxLength: 20,
            ),
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
                  passwordValidation(password.value);
                  await reSingInFire(ref.watch(userProvider)['email'], password.value);
                  await function();
                  navigator();
                  positiveSnackBar(context, text);
                } catch (e) {
                  negativeSnackBar(context, e.toString());
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
