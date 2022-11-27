import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'アカウント'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                '基本情報',
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
              title: const Text('メールアドレス'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/emailPage');
              },
            ),
            ListTile(
              title: const Text('パスワード'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/passwordPage');
              },
            ),
            const Divider(),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                '管理',
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
                              ref.read(bpPieChartStateProvider.notifier).boolChange();
                              ref.read(totalAssetsStateProvider.notifier).boolChange();
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
            GestureDetector(
              child: ListTile(
                title: Text('アカウント削除', style: TextStyle(color: negativeTextColor),),
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
                                    return ReSingInDialog(
                                      function: () async {
                                        await FirebaseAuth.instance.currentUser!.delete();
                                        ref.read(bpPieChartStateProvider.notifier).boolChange();
                                        ref.read(totalAssetsStateProvider.notifier).boolChange();
                                      },
                                      navigator: () {
                                        Navigator.popUntil(context,
                                                (Route<dynamic> route) => route.isFirst);
                                      },
                                      text: 'アカウントを削除しました',
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



