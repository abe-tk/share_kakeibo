// components
import 'package:share_kakeibo/components/indicator.dart';
// constant
import 'package:share_kakeibo/constant/colors.dart';
// view_model
import 'package:share_kakeibo/view_model/login/register_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterPage extends StatefulHookConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {

  @override
  void initState() {
    super.initState();
    ref.read(registerViewModelProvider.notifier).setInitialize();
  }

  @override
  Widget build(BuildContext context) {
    final _isObscure = useState(true);
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    controller: registerViewModelNotifier.userNameController,
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
                      labelText: 'ユーザー名',
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
                      registerViewModelNotifier.setUserName(text);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    controller: registerViewModelNotifier.emailController,
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
                      registerViewModelNotifier.setEmail(text);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    controller: registerViewModelNotifier.passwordController,
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
                            : Icons.visibility,
                        ),
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
                      registerViewModelNotifier.setPassword(text);
                    },
                    maxLength: 20,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    child: const Text(
                      'アカウントを新規登録する',
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: elevatedButtonColor,
                      side: BorderSide(
                        color: elevatedButtonBorderSideColor,
                        width: 1,
                      ),
                    ),
                    onPressed: () async {
                      indicator.showProgressDialog(context);
                      try {
                        await registerViewModelNotifier.signUp();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: positiveSnackBarColor,
                            behavior: SnackBarBehavior.floating,
                            content: Text('アカウントを作成しました！\nこちらからログインしてください'),
                          ),
                        );
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
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: const Divider(thickness: 3)),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    '既にアカウントをお持ちの方はこちらから',
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
