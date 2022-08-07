/// components
import 'package:share_kakeibo/components/indicator.dart';

/// view_model
import 'package:share_kakeibo/view_model/register/register_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterPage extends HookConsumerWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _isObscure = useState(true);
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
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: TextFormField(
                    controller: registerViewModel.userNameController,
                    decoration: const InputDecoration(
                      labelText: 'ユーザー名',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      registerViewModel.setUserName(text);
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
                    controller: registerViewModel.emailController,
                    decoration: const InputDecoration(
                      labelText: 'メールアドレス',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                    ),
                    onChanged: (text) {
                      registerViewModel.setEmail(text);
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
                    controller: registerViewModel.passwordController,
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
                      registerViewModel.setPassword(text);
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
                      elevation: 0,
                    ),
                    onPressed: () async {
                      indicator.showProgressDialog(context);
                      try {
                        await registerViewModel.signUp();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('アカウントを作成しました！\nこちらからログインしてください'),
                          ),
                        );
                      } catch (e) {
                        Navigator.of(context).pop();
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
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
