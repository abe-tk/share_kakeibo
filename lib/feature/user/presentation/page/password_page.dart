import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/common_widget/custom_text_field.dart';
import 'package:share_kakeibo/common_widget/dialog/input_text_dialog.dart';
import 'package:share_kakeibo/feature/auth/application/auth_service.dart';
import 'package:share_kakeibo/feature/auth/data/auth_repository_impl.dart';
import 'package:share_kakeibo/feature/user/data/user_repository.impl.dart';
import 'package:share_kakeibo/importer.dart';

class PasswordPage extends HookConsumerWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useState('');
    final passwordController = useTextEditingController(text: '');
    final _isObscurePassword = useState(true);

    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

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
                const SizedBox(height: 16),
                CustomElevatedButton(
                  text: '変更',
                  onTaped: () async {
                    try {
                      // パスワードのバリデーション
                      final validMessage =
                          Validator.validatePassword(value: password.value);
                      if (validMessage != null) {
                        final snackbar = CustomSnackBar(
                          context,
                          msg: validMessage,
                          color: Colors.red,
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                        return;
                      }

                      final reSignInPwd = await InputTextDialog.show(
                        context: context,
                        title: 'パスワードを入力',
                        hintText: 'パスワード',
                        isPassword: true,
                        confirmButtonText: '変更',
                      );
                      if (reSignInPwd != null) {
                        // パスワードのバリデーション
                        final validMessage =
                            Validator.validatePassword(value: reSignInPwd);
                        if (validMessage != null) {
                          final snackbar = CustomSnackBar(
                            context,
                            msg: validMessage,
                            color: Colors.red,
                          );
                          scaffoldMessenger.showSnackBar(snackbar);
                          return;
                        }

                        await ref.read(authServiceProvider).reSingIn(
                              email: userData!.email,
                              password: reSignInPwd,
                            );
                        await ref
                            .read(userRepositoryProvider)
                            .updatePassword(password: password.value);
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();

                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'パスワードを変更しました',
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                      }
                    } catch (e) {
                      logger.e(e.toString());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
