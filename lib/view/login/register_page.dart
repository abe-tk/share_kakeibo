import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/impoter.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userName = useState('');
    final email = useState('');
    final password = useState('');
    final userNameController = useState(TextEditingController());
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
                AppTextField(
                  controller: userNameController.value,
                  suffix: false,
                  obscure: false,
                  text: 'ユーザー名',
                  obscureChange: () {},
                  textChange: (text) => userName.value = text,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: emailController.value,
                  suffix: false,
                  obscure: false,
                  text: 'メールアドレス',
                  obscureChange: () {},
                  textChange: (text) => email.value = text,
                ),
                const SizedBox(height: 10),
                AppTextField(
                  controller: passwordController.value,
                  suffix: true,
                  obscure: _isObscure.value,
                  text: 'パスワード（6桁以上）',
                  obscureChange: () => _isObscure.value = !_isObscure.value,
                  textChange: (text) => password.value = text,
                ),
                const SizedBox(height: 16),
                AppElevatedButton(
                  text: '新規登録',
                  function: () async {
                    ref.watch(indicatorProvider).showProgressDialog(context);
                    changeLoginState(false); // app.dartでサインインの状態で判定されないようにするため
                    try {
                      await registerFire(userName.value, email.value, password.value);
                      await FirebaseAuth.instance.signOut(); // app.dartでサインインの状態で判定されないようにするため
                      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                      positiveSnackBar(context, 'アカウントを作成しました！\nこちらからログインしてください');
                    } on FirebaseAuthException catch (e) {
                      Navigator.of(context).pop();
                      negativeSnackBar(context, authValidation(e));
                    } catch (e) {
                      Navigator.of(context).pop();
                      negativeSnackBar(context, e.toString());
                    }
                  },
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Divider(thickness: 3)),
                AppTextButton(
                  text: '既にアカウントをお持ちの方はこちら',
                  size: 14,
                  color: Colors.grey,
                  function: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
