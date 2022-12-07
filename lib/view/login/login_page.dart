import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  void clearController(TextEditingController email, TextEditingController password) {
    email.clear();
    password.clear();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState('');
    final password = useState('');
    final emailController = useState(TextEditingController());
    final passwordController = useState(TextEditingController());
    final _isObscure = useState(true);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppThemeImage(),
                const SizedBox(height: 36),
                LoginTextField(
                  controller: emailController.value,
                  suffix: false,
                  obscure: false,
                  text: 'メールアドレス',
                  obscureChange: () {},
                  textChange: (text) => email.value = text,
                ),
                const SizedBox(height: 10),
                LoginTextField(
                  controller: passwordController.value,
                  suffix: true,
                  obscure: _isObscure.value,
                  text: 'パスワード（6桁以上）',
                  obscureChange: () => _isObscure.value = !_isObscure.value,
                  textChange: (text) => password.value = text,
                ),
                const SizedBox(height: 16),
                LoginElevatedButton(
                  text: 'ログイン',
                  function: () async {
                    ref.watch(indicatorProvider).showProgressDialog(context);
                    try {
                      await AuthFire().loginFire(email.value, password.value);
                      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                      clearController(emailController.value, passwordController.value);
                    } on FirebaseAuthException catch (e) {
                      Navigator.of(context).pop();
                      negativeSnackBar(context, authValidation(e));
                    } catch (e) {
                      Navigator.of(context).pop();
                      negativeSnackBar(context, e.toString());
                    }
                  },
                ),
                AppTextButton(
                  text: 'パスワードをお忘れ場合はこちら',
                  size: 14,
                  color: CustomColor.detailTextColor,
                  function: () {
                    Navigator.pushNamed(context, '/resetPasswordPage');
                    clearController(emailController.value, passwordController.value);
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Divider(thickness: 3),
                ),
                AppTextButton(
                  text: 'アカウントの新規登録はこちら',
                  size: 14,
                  color: CustomColor.detailTextColor,
                  function: () {
                    Navigator.pushNamed(context, '/registerPage');
                    clearController(emailController.value, passwordController.value);
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
