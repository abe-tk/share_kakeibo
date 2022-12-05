import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  void logout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AppAlertDialog(
          title: "ログアウトしますか？",
          subTitle: '',
          function: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
          },
        );
      },
    );
  }

  void deleteAccount(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AppAlertDialog(
          title: "アカウント削除",
          subTitle: 'アカウントを削除するとログインできなくなります。\nアカウントを削除しますか？',
          function: () async {
            try {
              showDialog(
                context: context,
                builder: (context) {
                  return ReSingInDialog(
                    function: () async => await FirebaseAuth.instance.currentUser!.delete(),
                    navigator: () => Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst),
                    text: 'アカウントを削除しました',
                  );
                },
              );
            } catch (e) {
              negativeSnackBar(context, e.toString());
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'アカウント'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingTitle(title: '基本情報'),
            SettingItem(
              title: 'メールアドレス',
              function: () => Navigator.pushNamed(context, '/emailPage'),
            ),
            SettingItem(
              title: 'パスワード',
              function: () => Navigator.pushNamed(context, '/passwordPage'),
            ),
            const Divider(),
            const SettingTitle(title: '管理'),
            SettingItem(
              title: 'ログアウト',
              function: () => logout(context, ref),
            ),
            SettingItem(
              title: 'アカウントを削除',
              function: () => deleteAccount(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}



