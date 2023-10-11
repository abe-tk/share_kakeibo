import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/feature/login/data/login_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginNotifier = ref.watch(loginRepositoryProvider);
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    // ユーザー名
    final userName = useState('');
    final userNameController = useState(TextEditingController());

    // メールアドレス
    final email = useState('');
    final emailController = useState(TextEditingController());

    // パスワード
    final password = useState('');
    final passwordController = useState(TextEditingController());

    // パスワードの非表示
    final _isObscure = useState(true);

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 36),
              child: Column(
                children: [
                  const Logo(),
                  const SizedBox(height: 32),
                  LoginTextField(
                    labelText: 'ユーザー名',
                    controller: userNameController.value,
                    textChange: (text) => userName.value = text,
                  ),
                  const SizedBox(height: 16),
                  LoginTextField(
                    labelText: 'メールアドレス',
                    controller: emailController.value,
                    textChange: (text) => email.value = text,
                  ),
                  const SizedBox(height: 16),
                  LoginTextField(
                    labelText: 'パスワード（6桁以上）',
                    controller: passwordController.value,
                    textChange: (text) => password.value = text,
                    isObscure: _isObscure.value,
                    isObscureChange: () => _isObscure.value = !_isObscure.value,
                  ),
                  const SizedBox(height: 16),
                  CustomElevatedButton(
                    text: '新規登録',
                    onTaped: () async {
                      showProgressDialog(context);
                      try {
                        registerValidation(
                          userName.value,
                          email.value,
                          password.value,
                        );
                        await loginNotifier.register(
                          uidProvider: ref.read(uidProvider.notifier).state,
                          userName: userName.value,
                          email: email.value,
                          password: password.value,
                        );
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'アカウントの新規登録が完了しました',
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
                      '既にアカウントをお持ちの方はこちら',
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
