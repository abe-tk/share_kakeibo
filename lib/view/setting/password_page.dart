import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class PasswordPage extends HookConsumerWidget {
  const PasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = useState('');
    final passwordController = useState(TextEditingController(text: ''));
    final checkPassword = useState('');
    final checkPasswordController = useState(TextEditingController(text: ''));
    final _isObscurePassword = useState(true);
    final _isObscureCheckPassword = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'パスワードを変更',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                updatePasswordValidation(password.value, checkPassword.value);
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReSingInDialog(
                      function: () async {
                        await updateUserPasswordFire(password.value);
                      },
                      navigator: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      text: 'パスワードを変更しました',
                    );
                  },
                );
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: negativeSnackBarColor,
                  behavior: SnackBarBehavior.floating,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(Icons.check, color: positiveIconColor,),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '変更後のパスワード',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: TextFormField(
                      controller: passwordController.value,
                      obscureText: _isObscurePassword.value,
                      decoration: InputDecoration(
                        hintText: 'パスワード（6〜20文字）',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscurePassword.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            _isObscurePassword.value = !_isObscurePassword.value;
                          },
                        ),
                      ),
                      onChanged: (text) {
                        password.value = text;
                      },
                      // maxLength: 20,
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '変更後のパスワード（確認用）',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: TextFormField(
                      controller: checkPasswordController.value,
                      obscureText: _isObscureCheckPassword.value,
                      decoration: InputDecoration(
                        hintText: 'パスワード（6〜20文字）',
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(_isObscureCheckPassword.value
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () {
                            _isObscureCheckPassword.value = !_isObscureCheckPassword.value;
                          },
                        ),
                      ),
                      onChanged: (text) {
                        checkPassword.value = text;
                      },
                      // maxLength: 20,
                    ),
                  ),
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
