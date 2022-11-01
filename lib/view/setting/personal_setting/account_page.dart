// constant
import 'package:share_kakeibo/constant/colors.dart';
// view
import 'package:share_kakeibo/view/setting/personal_setting/widgets/delete_account_password_dialog.dart';
// view_model
import 'package:share_kakeibo/view_model/setting/personal_setting/widgets/password_dialog_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final passwordDialogViewModelNotifier = ref.watch(passwordDialogViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'アカウント',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                'メールアドレス',
                style: TextStyle(
                  color: detailTextColor,
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: dividerColor,
            ),
            ListTile(
              title: const Text('メールアドレスを変更'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/emailPage');
              },
            ),
            const Divider(),
            /// アカウントのパスワード変更の機能を追加予定
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: const EdgeInsets.all(16),
            //   child: const Text(
            //     'パスワード',
            //     style: TextStyle(
            //       color: Color.fromRGBO(65, 65, 65, 0.8),
            //     ),
            //   ),
            // ),
            // const Divider(
            //   height: 0,
            //   thickness: 1,
            //   indent: 16,
            //   endIndent: 16,
            //   color: Colors.grey,
            // ),
            // ListTile(
            //   title: const Text('パスワードを変更'),
            //   trailing: const Icon(Icons.chevron_right),
            //   onTap: () {
            //     // Navigator.pushNamed(context, '/roomInfoPage');
            //   },
            // ),
            // const Divider(),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                'ログイン',
                style: TextStyle(
                  color: detailTextColor,
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: dividerColor,
            ),
            GestureDetector(
              child: ListTile(
                title: const Text('ログアウト'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("ログアウトしますか？"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.popUntil(context,
                                      (Route<dynamic> route) => route.isFirst);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                'アカウント',
                style: TextStyle(
                  color: detailTextColor,
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: dividerColor,
            ),
            GestureDetector(
              child: ListTile(
                title: Text('アカウントを削除', style: TextStyle(color: negativeTextColor),),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("アカウント削除"),
                        content: const Text('アカウントを削除するとログインできなくなります。\nアカウントを削除しますか？'),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () async {
                              try {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return const DeleteAccountPasswordDialog();
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
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



