import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/custom_text_field.dart';
import 'package:share_kakeibo/importer.dart';

class EmailPage extends HookConsumerWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beforeUserData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    final email = useState('');
    final emailController =
        useTextEditingController(text: beforeUserData!.email);

    final roomCode = ref.watch(roomCodeProvider(ref.watch(uidProvider))).whenOrNull(
          data: (data) => data,
        );

    Future<void> updateEmail() async {
      try {
        updateEmailValidation(email.value, beforeUserData.email);
        showDialog(
          context: context,
          builder: (context) {
            return ReSingInDialog(
              function: () async {
                email.value = emailController.value.text;
                ref.read(userInfoProvider.notifier).updateUser(
                      uid: ref.watch(uidProvider),
                      roomCode: roomCode!,
                      userData: beforeUserData,
                      email: email.value,
                    );
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
                  text: '保存',
                  onTaped: () async => updateEmail(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
