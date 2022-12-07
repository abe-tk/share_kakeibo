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

    Future<void> updatePassword() async {
      try {
        updatePasswordValidation(password.value, checkPassword.value);
        showDialog(
          context: context,
          builder: (context) {
            return ReSingInDialog(
              function: () async {
                await AuthFire().updateUserPasswordFire(password.value);
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
        negativeSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: ActionAppBar(
        title: 'パスワードを変更',
        icon: Icons.check,
        iconColor: CustomColor.positiveIconColor,
        function: () async => updatePassword(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SettingTitle(title: '変更後のパスワード'),
                SettingTextField(
                  controller: passwordController.value,
                  suffix: true,
                  obscure: _isObscurePassword.value,
                  text: 'パスワード（6〜20文字）',
                  obscureChange: () => _isObscurePassword.value = !_isObscurePassword.value,
                  textChange: (text) => password.value = text,
                ),
                const Divider(),
                const SettingTitle(title: '変更後のパスワード（確認用）'),
                SettingTextField(
                  controller: checkPasswordController.value,
                  suffix: true,
                  obscure: _isObscureCheckPassword.value,
                  text: 'パスワード（6〜20文字）',
                  obscureChange: () => _isObscureCheckPassword.value = !_isObscureCheckPassword.value,
                  textChange: (text) => checkPassword.value = text,
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
