import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // authのサービス
    final authService = ref.watch(authServiceProvider);

    // userのサービス
    final userService = ref.watch(userServiceProvider);

    // roomのサービス
    final roomService = ref.watch(roomServiceProvider);

    // snackbarの設定
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    // ユーザー名
    final userName = useState('');
    final userNameController = useTextEditingController();

    // メールアドレス
    final email = useState('');
    final emailController = useTextEditingController();

    // パスワード
    final password = useState('');
    final passwordController = useTextEditingController();

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
                  const Image(
                    image: AssetImage('assets/image/app_theme.png'),
                    height: 160,
                    width: 160,
                  ),
                  const SizedBox(height: 32),
                  LoginTextField(
                    labelText: 'ユーザー名',
                    controller: userNameController,
                    textChange: (text) => userName.value = text,
                  ),
                  const SizedBox(height: 16),
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

                        // ユーザー情報の登録
                        userService.createUser(
                          uid: uid,
                          userName: userName.value,
                          email: email.value,
                          imgURL: imgURL,
                        );

                        // ルームの作成
                        roomService.createRoom(
                          uid: uid,
                          userName: userName.value,
                          email: email.value,
                          imgURL: imgURL,
                        );

                        // uidの更新
                        ref.invalidate(uidProvider);

                        // ホーム画面へ遷移
                        Navigator.popUntil(
                          context,
                          (Route<dynamic> route) => route.isFirst,
                        );

                        // メッセージの表示
                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'アカウントの新規登録が完了しました',
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
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
