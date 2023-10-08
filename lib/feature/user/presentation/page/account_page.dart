import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/dialog/input_text_dialog.dart';
import 'package:share_kakeibo/feature/login/data/login_repository_impl.dart';
import 'package:share_kakeibo/feature/user/data/user_repository.impl.dart';
import 'package:share_kakeibo/importer.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

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
                onTaped: () async {
                  final isLogout = await ConfirmDialog.show(
                    context: context,
                    title: 'ログアウトしますか？',
                    confirmButtonText: 'ログアウト',
                    confirmButtonTextStyle: context.bodyMediumRed,
                  );
                  if (isLogout) {
                    await ref.read(loginRepositoryProvider).signOut();
                    Navigator.popUntil(
                        context, (Route<dynamic> route) => route.isFirst);
                  }
                },
              ),
              CustomListTile(
                title: 'アカウントを削除',
                leading: const Icon(Icons.remove_circle_outline),
                onTaped: () async {
                  final isDeleteAccount = await ConfirmDialog.show(
                    context: context,
                    title: 'アカウントを削除しますか？',
                    message: 'アカウントを削除するとログインできなくなります。',
                    confirmButtonText: '削除',
                    confirmButtonTextStyle: context.bodyMediumRed,
                  );
                  if (isDeleteAccount) {
                    final password = await InputTextDialog.show(
                      context: context,
                      title: 'パスワードを入力',
                      hintText: 'パスワード',
                      isPassword: true,
                      confirmButtonText: '削除',
                    );
                    if (password != null) {
                      try {
                        passwordValidation(password);
                        await ref.read(loginRepositoryProvider).reSingIn(
                              email: userData!.email,
                              password: password,
                            );
                        await ref.read(userRepositoryProvider).deleteAccount();
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                        positiveSnackBar(context, 'アカウントを削除しました');
                      } catch (e) {
                        negativeSnackBar(context, e.toString());
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
