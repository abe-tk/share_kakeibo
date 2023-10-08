import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/custom_list_tile.dart';
import 'package:share_kakeibo/feature/login/data/login_repository_impl.dart';
import 'package:share_kakeibo/feature/user/data/user_repository.impl.dart';
import 'package:share_kakeibo/importer.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void logout() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomAlertDialog(
            title: "ログアウトしますか？",
            subTitle: '',
            function: () async {
              await ref.read(loginRepositoryProvider).signOut();
              Navigator.popUntil(
                  context, (Route<dynamic> route) => route.isFirst);
            },
          );
        },
      );
    }

    void deleteAccount() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomAlertDialog(
            title: "アカウント削除",
            subTitle: 'アカウントを削除するとログインできなくなります。\nアカウントを削除しますか？',
            function: () async {
              try {
                showDialog(
                  context: context,
                  builder: (context) {
                    return ReSingInDialog(
                      function: () async => await ref
                          .read(userRepositoryProvider)
                          .deleteAccount(),
                      navigator: () => Navigator.popUntil(
                          context, (Route<dynamic> route) => route.isFirst),
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

    return Scaffold(
      appBar: const CustomAppBar(title: 'アカウント'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SubTitle(title: '基本情報'),
              CustomListTile(
                title: 'メールアドレス',
                leading: const Icon(Icons.mail),
                onTaped: () => Navigator.pushNamed(context, '/emailPage'),
              ),
              CustomListTile(
                title: 'パスワード',
                leading: const Icon(Icons.key),
                onTaped: () => Navigator.pushNamed(context, '/passwordPage'),
              ),
              const SizedBox(height: 16),
              const SubTitle(title: '管理'),
              CustomListTile(
                title: 'ログアウト',
                leading: const Icon(Icons.exit_to_app),
                onTaped: () => logout(),
              ),
              CustomListTile(
                title: 'アカウントを削除',
                leading: const Icon(Icons.remove_circle_outline),
                onTaped: () => deleteAccount(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
