// constant
import 'package:share_kakeibo/constant/validation.dart';
import 'package:share_kakeibo/constant/colors.dart';
// view
import 'package:share_kakeibo/view/setting/personal_setting/widgets/change_email_password_dialog.dart';
// view_model
import 'package:share_kakeibo/view_model/setting/personal_setting/email_view_model.dart';
import 'package:share_kakeibo/view_model/setting/personal_setting/widgets/password_dialog_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EmailPage extends StatefulHookConsumerWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends ConsumerState<EmailPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(emailViewModelProvider.notifier).fetchEmail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailViewModelState = ref.watch(emailViewModelProvider);
    final emailViewModelNotifier = ref.watch(emailViewModelProvider.notifier);
    final passwordDialogViewModelNotifier = ref.watch(passwordDialogViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'メールアドレス',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                updateEmailValidation(emailViewModelState, emailViewModelNotifier.email);
                showDialog(
                  context: context,
                  builder: (context) {
                    return const ChangeEmailPasswordDialog();
                  },
                );
                passwordDialogViewModelNotifier.clearPassword();
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
                    '現在のメールアドレス',
                    style: TextStyle(color: detailTextColor),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ListTile(
                    title: Text(emailViewModelNotifier.email ?? ''),
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
                      controller: emailViewModelNotifier.emailController,
                      decoration: const InputDecoration(
                        hintText: 'メールアドレス',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        emailViewModelNotifier.setEmail(text);
                      },
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
