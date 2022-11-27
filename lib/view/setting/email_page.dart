import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class EmailPage extends HookConsumerWidget {
  const EmailPage({Key? key}) : super(key: key);

  Future <void> updateEmail(String email, TextEditingController emailController) async {
    email = emailController.text;
    await updateUserEmailFire(email);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState(ref.watch(userProvider)['email']);
    final emailController = useState(TextEditingController(text: ref.watch(userProvider)['email']));
    return Scaffold(
      appBar: ActionAppBar(
        title: 'メールアドレスを変更',
        icon: Icons.check,
        iconColor: positiveIconColor,
        function: () async {
          try {
            updateEmailValidation(email.value, ref.watch(userProvider)['email']);
            showDialog(
              context: context,
              builder: (context) {
                return ReSingInDialog(
                  function: () async {
                    await updateEmail(email.value, emailController.value);
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
            final snackBar = SnackBar(
              backgroundColor: negativeSnackBarColor,
              behavior: SnackBarBehavior.floating,
              content: Text(e.toString()),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
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
                    '現在のメールアドレス',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: Text(ref.watch(userProvider)['email']),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    '変更後のメールアドレス',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: TextField(
                      textAlign: TextAlign.left,
                      controller: emailController.value,
                      decoration: const InputDecoration(
                        hintText: 'メールアドレス',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) => email.value = text,
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
