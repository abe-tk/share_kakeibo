import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class EmailPage extends HookConsumerWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState('');
    final emailController = useState(TextEditingController(text: ''));

    Future <void> updateEmail() async {
      try {
        updateEmailValidation(email.value, ref.watch(userProvider)['email']);
        showDialog(
          context: context,
          builder: (context) {
            return ReSingInDialog(
              function: () async {
                email.value = emailController.value.text;
                await UserFire().updateUserEmailFire(email.value);
                await ref.read(userProvider.notifier).fetchUser();
              },
              navigator: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              text: 'メールアドレスを変更しました',
            );
          },
        );
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: ActionAppBar(
        title: 'メールアドレスを変更',
        icon: Icons.check,
        iconColor: CustomColor.positiveIconColor,
        function: () async => updateEmail(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SettingTitle(title: '現在のメールアドレス'),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: Text(ref.watch(userProvider)['email']),
                  ),
                ),
                const Divider(),
                const SettingTitle(title: '変更後のメールアドレス'),
                SettingTextField(
                  controller: emailController.value,
                  suffix: false,
                  obscure: false,
                  text: 'メールアドレスを入力',
                  obscureChange: () {},
                  textChange: (text) => email.value = text,
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
