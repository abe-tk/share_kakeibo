import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/common_widget/custom_text_field.dart';
import 'package:share_kakeibo/feature/user/data/user_repository.impl.dart';
import 'package:share_kakeibo/importer.dart';

class PasswordPage extends HookConsumerWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useState('');
    final passwordController = useTextEditingController(text: '');
    final checkPassword = useState('');
    final checkPasswordController = useTextEditingController(text: '');
    final _isObscurePassword = useState(true);

    Future<void> updatePassword() async {
      try {
        updatePasswordValidation(password.value, checkPassword.value);
        showDialog(
          context: context,
          builder: (context) {
            return ReSingInDialog(
              function: () async {
                await ref
                    .read(userRepositoryProvider)
                    .updatePassword(password: password.value);
              },
              navigator: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              text: 'パスワードを変更しました',
            );
          },
        );
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'パスワードを変更'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SubTitle(title: '変更後のパスワード'),
                CustomTextField(
                  hintText: 'パスワード（6〜20文字）',
                  controller: passwordController,
                  textChange: (text) => password.value = text,
                  isObscure: _isObscurePassword.value,
                  isObscureChange: () =>
                      _isObscurePassword.value = !_isObscurePassword.value,
                ),
                const SubTitle(title: '変更後のパスワード（確認用）'),
                CustomTextField(
                  hintText: 'パスワード（6〜20文字）',
                  controller: checkPasswordController,
                  textChange: (text) => checkPassword.value = text,
                  isObscure: _isObscurePassword.value,
                  isObscureChange: () =>
                      _isObscurePassword.value = !_isObscurePassword.value,
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  text: '保存',
                  onTaped: () async => updatePassword(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
