/// components
import 'package:share_kakeibo/components/auth_fire.dart';
import 'package:share_kakeibo/components/indicator.dart';

/// view
import 'package:share_kakeibo/view/register/register_page.dart';

/// view_model
import 'package:share_kakeibo/view_model/login/login_view_model.dart';
import 'package:share_kakeibo/view_model/register/register_view_model.dart';

/// packages
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
  Widget build(BuildContext context) {
    final _isObscure = useState(true);
    final loginViewModel = ref.watch(loginViewModelProvider);
    final registerViewModel = ref.watch(registerViewModelProvider);
    final indicator = ref.watch(indicatorProvider);
    return SafeArea(
      child: Scaffold(
        body: Center(
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
                    controller: loginViewModel.emailController,
                    decoration: const InputDecoration(
                      labelText: 'メールアドレス',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      loginViewModel.setEmail(text);
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
                    controller: loginViewModel.passwordController,
                    obscureText: _isObscure.value,
                    decoration: InputDecoration(
                      labelText: 'パスワード（6〜20文字）',
                      suffixIcon: IconButton(
                        icon: Icon(_isObscure.value
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          _isObscure.value = !_isObscure.value;
                        },
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      loginViewModel.setPassword(text);
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
                        await loginViewModel.login();
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                        loginViewModel.clearEmail();
                        loginViewModel.clearPassword();
                        /// uidをログインユーザのものに変更
                        changeUid();
                      } catch (e) {
                        Navigator.of(context).pop();
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('ログイン'),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
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
                    loginViewModel.clearEmail();
                    loginViewModel.clearPassword();
                    registerViewModel.clearUserName();
                    registerViewModel.clearEmail();
                    registerViewModel.clearPassword();
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
