import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_kakeibo/constant/img_url.dart';
import 'package:share_kakeibo/feature/auth/application/auth_service.dart';
import 'package:share_kakeibo/importer.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authのサービス
    final authService = ref.watch(authServiceProvider);

    // snackbarの設定
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
                      Indicator.show(context);
                      try {
                        // ユーザー名、メールアドレス、パスワードのバリデーション
                        final validMessage = Validator.validateUserName(
                                value: userName.value) ??
                            Validator.validateEmail(value: email.value) ??
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

                        // 新規登録
                        final userCredential = await authService.register(
                          email: email.value,
                          password: password.value,
                        );
                        final uid = userCredential.user!.uid;

                        /// 以下の処理はUserのProviderで行いたい
                        // ユーザー情報の登録
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .set({
                          'userName': userName.value,
                          'email': email.value,
                          'imgURL': imgURL,
                          'roomCode': uid,
                          'roomName': '${userName.value}のルーム',
                        });
                        // ルーム情報の登録
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(uid)
                            .collection('room')
                            .doc(uid)
                            .set({
                          'userName': userName.value,
                          'imgURL': imgURL,
                          'owner': true,
                        });
                        /// 上記の処理はUserのProviderで行いたい

                        // uidの更新
                        ref.invalidate(uidProvider);

                        // ホーム画面へ遷移
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
                      'アカウントをお持ちの方はこちら',
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
