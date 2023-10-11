import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/custom_text_field.dart';
import 'package:share_kakeibo/common_widget/dialog/input_text_dialog.dart';
import 'package:share_kakeibo/feature/login/data/login_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

class EmailPage extends HookConsumerWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beforeUserData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    final email = useState(beforeUserData!.email);
    final emailController = useTextEditingController(
      text: beforeUserData.email,
    );

    final roomCode = ref.watch(roomCodeProvider).whenOrNull(
          data: (data) => data,
        );

    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    return Scaffold(
      appBar: const CustomAppBar(title: 'メールアドレスを変更'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SubTitle(title: 'メールアドレス'),
                CustomTextField(
                  hintText: 'メールアドレスを入力',
                  controller: emailController,
                  textChange: (text) => email.value = text,
                ),
                const SizedBox(height: 16),
                CustomElevatedButton(
                  text: '変更',
                  onTaped: () async {
                    try {
                      updateEmailValidation(email.value, beforeUserData.email);
                      final password = await InputTextDialog.show(
                        context: context,
                        title: 'パスワードを入力',
                        hintText: 'パスワード',
                        isPassword: true,
                        confirmButtonText: '変更',
                      );
                      if (password != null) {
                        passwordValidation(password);
                        await ref.read(loginRepositoryProvider).reSingIn(
                              email: userData!.email,
                              password: password,
                            );
                        email.value = emailController.value.text;
                        ref.read(userInfoProvider.notifier).updateUser(
                              uid: ref.watch(uidProvider),
                              roomCode: roomCode!,
                              userData: beforeUserData,
                              email: email.value,
                            );
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        final snackbar = CustomSnackBar(
                          context,
                          msg: 'メールアドレスを変更しました',
                        );
                        scaffoldMessenger.showSnackBar(snackbar);
                      }
                    } catch (e) {
                      final snackbar = CustomSnackBar(
                        context,
                        msg: 'エラーが発生しました。\nもう一度お試しください。',
                        color: Colors.red,
                      );
                      scaffoldMessenger.showSnackBar(snackbar);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
