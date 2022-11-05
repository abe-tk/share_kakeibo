// components
import 'package:share_kakeibo/components/indicator.dart';
// constant
import 'package:share_kakeibo/constant/colors.dart';
// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
// view
import 'package:share_kakeibo/view/login/register_page.dart';
// view_model
import 'package:share_kakeibo/view_model/login/login_view_model.dart';
import 'package:share_kakeibo/view_model/login/register_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginPage extends StatefulHookConsumerWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {

  @override
  void initState() {
    super.initState();
    ref.read(loginViewModelProvider.notifier).setInitialize();
  }

  @override
  Widget build(BuildContext context) {
    final _isObscure = useState(true);
    final loginViewModelNotifier = ref.watch(loginViewModelProvider.notifier);
    final registerViewModelNotifier = ref.watch(registerViewModelProvider.notifier);
    final indicator = ref.watch(indicatorProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Image(
                  image: AssetImage('assets/image/app_theme.png'),
                  height: 160,
                  width: 160,
                ),
                const SizedBox(height: 36),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: loginViewModelNotifier.emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: textFieldBorderSideColor,
                          width: 2.0,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: textFieldTextColor,
                      ),
                      labelText: 'メールアドレス',
                      floatingLabelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: textFieldBorderSideColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      loginViewModelNotifier.setEmail(text);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextFormField(
                    controller: loginViewModelNotifier.passwordController,
                    obscureText: _isObscure.value,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: textFieldBorderSideColor,
                          width: 2.0,
                        ),
                      ),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: textFieldTextColor,
                      ),
                      labelText: 'パスワード（6〜20文字）',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          _isObscure.value = !_isObscure.value;
                        },
                      ),
                      floatingLabelStyle: const TextStyle(fontSize: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: textFieldBorderSideColor,
                          width: 1.0,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      loginViewModelNotifier.setPassword(text);
                    },
                    maxLength: 20,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: () async {
                      indicator.showProgressDialog(context);
                      try {
                        await loginViewModelNotifier.login();
                        Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                        loginViewModelNotifier.clearTextController();
                        // uidをログインユーザのものに変更
                        changeUid();
                      } catch (e) {
                        Navigator.of(context).pop();
                        final snackBar = SnackBar(
                          backgroundColor: negativeSnackBarColor,
                          behavior: SnackBarBehavior.floating,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('ログイン'),
                    style: ElevatedButton.styleFrom(
                      primary: elevatedButtonColor,
                      side: BorderSide(
                        color: elevatedButtonBorderSideColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: const Divider(thickness: 3),
                ),
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                        fullscreenDialog: true,
                      ),
                    );
                    loginViewModelNotifier.clearTextController();
                    registerViewModelNotifier.clearTextController();
                  },
                  child: const Text(
                    'アカウントの新規登録はこちらから',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
