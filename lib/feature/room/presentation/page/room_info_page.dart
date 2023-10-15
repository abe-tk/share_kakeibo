import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/dialog/input_text_dialog.dart';
import 'package:share_kakeibo/feature/auth/application/auth_service.dart';
import 'package:share_kakeibo/importer.dart';

class RoomInfoPage extends HookConsumerWidget {
  const RoomInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomNameState = ref.watch(roomNameProvider);
    final roomMemberState = ref.watch(roomMemberProvider);

    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    final roomCode = ref.watch(roomCodeProvider).whenOrNull(
          data: (data) => data,
        );

    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'ROOM情報',
        icon: Icons.logout,
        iconColor: Colors.black,
        onTaped: () async {
          final isExit = await ConfirmDialog.show(
            context: context,
            title: 'ルームから退出しますか？',
            message: '「${userData!.userName}」が登録した収支データは削除されます。',
            confirmButtonText: '退出する',
            confirmButtonTextStyle: context.bodyMediumRed,
          );
          if (isExit) {
            try {
              if (ref.watch(uidProvider) == roomCode!) {
                // ルームオーナーかの判定
                final snackbar = CustomSnackBar(
                  context,
                  msg: 'RoomOwnerは退出できません',
                  color: Colors.red,
                );
                scaffoldMessenger.showSnackBar(snackbar);
                return;
              }
              final password = await InputTextDialog.show(
                context: context,
                title: 'パスワードを入力',
                hintText: 'パスワード',
                isPassword: true,
                confirmButtonText: '退出する',
              );
              if (password != null) {
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
                      email: userData.email,
                      password: password,
                    );
                await ref.read(roomMemberProvider.notifier).exitRoom(
                      roomCode: roomCode,
                      userName: userData.userName,
                    );
                // 各Stateを更新
                ref.invalidate(roomCodeProvider);
                ref.read(userInfoProvider.notifier).readUser();

                Navigator.popUntil(
                    context, (Route<dynamic> route) => route.isFirst);
                final snackbar = CustomSnackBar(
                  context,
                  msg: 'Roomから退出しました',
                );
                scaffoldMessenger.showSnackBar(snackbar);
              }
            } catch (e) {
              logger.e(e.toString());
            }
          }
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SubTitle(title: 'ROOM名'),
              roomNameState.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => const Text('error'),
                data: (data) => CustomListTile(
                  title: data,
                  leading: const Icon(Icons.meeting_room),
                  onTaped: () => Navigator.pushNamed(context, '/roomNamePage'),
                ),
              ),
              const SizedBox(height: 16),
              const SubTitle(title: 'ROOMのメンバー'),
              roomMemberState.when(
                loading: () => const CircularProgressIndicator(),
                error: (error, stack) => const Text('error'),
                data: (data) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          data[index].imgURL,
                        ),
                      ),
                      title: Text(data[index].userName),
                      subtitle: (data[index].owner == true)
                          ? const Text('owner')
                          : const Text(''),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
