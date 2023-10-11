import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/feature/login/data/login_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginNotifier = ref.watch(loginRepositoryProvider);
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
                        resetPasswordValidation(email.value);
                        await loginNotifier.resetPassword(email: email.value);
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
                          msg: authValidation(e),
                          color: Colors.red,
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                      } catch (e) {
                        Navigator.of(context).pop();
                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'エラーが発生しました。\nもう一度お試しください。',
                          color: Colors.red,
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
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
