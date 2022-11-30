import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/impoter.dart';

class ResetPasswordPage extends HookConsumerWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState('');
    final emailController = useState(TextEditingController());
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const AppThemeImage(),
                const SizedBox(height: 16),
                const Text('パスワード再設定メールを送信',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),),
                const SizedBox(height: 36),
                LoginTextField(
                  controller: emailController.value,
                  suffix: false,
                  obscure: false,
                  text: 'メールアドレス',
                  obscureChange: () {},
                  textChange: (text) => email.value = text,
                ),
                const SizedBox(height: 36),
                LoginElevatedButton(
                  text: '送信',
                  function: () async {
                    ref.watch(indicatorProvider).showProgressDialog(context);
                    try {
                      resetPasswordValidation(email.value);
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.value);
                      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                      positiveSnackBar(context, 'パスワード再設定メールを送信しました');
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
                  text: 'ログイン画面へ戻る',
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
