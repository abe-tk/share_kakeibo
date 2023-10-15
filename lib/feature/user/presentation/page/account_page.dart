import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/dialog/input_text_dialog.dart';
import 'package:share_kakeibo/feature/auth/application/auth_service.dart';
import 'package:share_kakeibo/feature/user/data/user_repository.impl.dart';
import 'package:share_kakeibo/importer.dart';

class AccountPage extends HookConsumerWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

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
                // onTaped: () => Navigator.pushNamed(context, '/emailPage'),
                // TODO: routerに含める
                onTaped: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return EmailPage(beforeUserData: userData);
                    },
                  ),
                ),
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
                    await ref.read(authServiceProvider).signOut();
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
                        // パスワードのバリデーション
                        final validMessage =
                            Validator.validatePassword(value: password);
                        if (validMessage != null) {
                          final snackbar = CustomSnackBar(
                            context,
                            msg: validMessage,
                            color: Colors.red,
                          );
                          scaffoldMessenger.showSnackBar(snackbar);
                          return;
                        }

                        await ref.read(authServiceProvider).reSingIn(
                              email: userData!.email,
                              password: password,
                            );
                        await ref.read(userRepositoryProvider).deleteAccount();
                        Navigator.popUntil(
                            context, (Route<dynamic> route) => route.isFirst);
                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'アカウントを削除しました',
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                      } catch (e) {
                        logger.e(e.toString());
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
