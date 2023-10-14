import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/feature/auth/application/auth_service.dart';
import 'package:share_kakeibo/importer.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authのサービス
    final authService = ref.watch(authServiceProvider);

    // snackbarの設定
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    // メールアドレス
    final email = useState('');
    final emailController = useState(TextEditingController());

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  const Logo(),
                  const SizedBox(height: 16),
                  Text(
                    'パスワード再設定メールを送信',
                    style: context.bodyLargeBold,
                  ),
                  const SizedBox(height: 32),
                  LoginTextField(
                    labelText: 'メールアドレス',
                    controller: emailController.value,
                    textChange: (text) => email.value = text,
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    text: '送信',
                    onTaped: () async {
                      showProgressDialog(context);
                      try {
                        // メールアドレスのバリデーション
                        final validMessage =
                            Validator.validateEmail(value: email.value);
                        if (validMessage != null) {
                          final snackbar = CustomSnackBar(
                            context,
                            msg: validMessage,
                            color: Colors.red,
                          );
                          scaffoldMessenger.showSnackBar(snackbar);
                          return;
                        }

                        // メール送信処理
                        await authService.resetPassword(email: email.value);

                        // メール送信処理後、ログイン画面へ戻る
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'パスワード再設定メールを送信しました',
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                      } on FirebaseAuthException catch (e) {
                        Navigator.of(context).pop();
                        final snackbar = CustomSnackBar(
                          context,
                          msg: authService.getErrorMessage(e),
                          color: Colors.red,
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                      } catch (e) {
                        Navigator.of(context).pop();
                        logger.e(e.toString());
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  TextButton(
                    child: Text(
                      'ログイン画面へ戻る',
                      style: context.bodyMediumGrey,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
