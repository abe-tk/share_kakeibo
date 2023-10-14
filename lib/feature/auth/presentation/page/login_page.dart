import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/feature/auth/application/auth_service.dart';
import 'package:share_kakeibo/importer.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authのサービス
    final authService = ref.watch(authServiceProvider);

    // snackbarの設定
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    // メールアドレス
    final email = useState('');
    final emailController = useTextEditingController();

    // パスワード
    final password = useState('');
    final passwordController = useTextEditingController();

    // パスワードの非表示
    final _isObscure = useState(true);

    // テキストの初期化
    void clearText() {
      emailController.clear();
      passwordController.clear();
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/image/app_theme.png'),
                    height: 160,
                    width: 160,
                  ),
                  const SizedBox(height: 32),
                  LoginTextField(
                    labelText: 'メールアドレス',
                    controller: emailController,
                    textChange: (text) => email.value = text,
                  ),
                  const SizedBox(height: 16),
                  LoginTextField(
                    labelText: 'パスワード（6桁以上）',
                    controller: passwordController,
                    textChange: (text) => password.value = text,
                    isObscure: _isObscure.value,
                    isObscureChange: () => _isObscure.value = !_isObscure.value,
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    text: 'ログイン',
                    onTaped: () async {
                      // ローディングの表示
                      Indicator.show(context);
                      try {
                        // メールアドレスとパスワードのバリデーション
                        final validMessage = Validator.validateEmail(
                                value: email.value) ??
                            Validator.validatePassword(value: password.value);
                        if (validMessage != null) {
                          Navigator.of(context).pop();
                          final snackbar = CustomSnackBar(
                            context,
                            msg: validMessage,
                            color: Colors.red,
                          );
                          scaffoldMessenger.showSnackBar(snackbar);
                          return;
                        }

                        // サインイン
                        await authService.singIn(
                          email: email.value,
                          password: password.value,
                        );

                        // uidの更新
                        ref.invalidate(uidProvider);

                        // ホーム画面へ遷移
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);

                        // メッセージの表示
                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'ログインしました',
                        );
                        scaffoldMessenger.showSnackBar(snackbar);

                        // テキストの初期化
                        clearText();
                      } on FirebaseAuthException catch (e) {
                        // ローディングの表示解除
                        Navigator.of(context).pop();

                        // エラーメッセージの表示
                        final snackbar = CustomSnackBar(
                          context,
                          msg: authService.getErrorMessage(e),
                          color: Colors.red,
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                      } catch (e) {
                        // ローディングの表示解除
                        Navigator.of(context).pop();
                        logger.e(e.toString());
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    child: Text(
                      'パスワードをお忘れ場合はこちら',
                      style: context.bodyMediumGrey,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/resetPasswordPage');
                      clearText();
                    },
                  ),
                  const Divider(),
                  TextButton(
                    child: Text(
                      'アカウントの新規登録はこちら',
                      style: context.bodyMediumGrey,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/registerPage');
                      clearText();
                    },
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
