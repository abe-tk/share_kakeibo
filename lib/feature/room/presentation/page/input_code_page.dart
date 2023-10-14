import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/common_widget/custom_text_field.dart';
import 'package:share_kakeibo/feature/room/data/room_repository_impl.dart';
import 'package:share_kakeibo/importer.dart';

class InputCodePage extends HookConsumerWidget {
  const InputCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCode = useState('');
    final roomCodeController = useTextEditingController();
    final ownerRoomName = useState('');

    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    return Scaffold(
      appBar: const CustomAppBar(title: 'ROOMに参加する'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SubTitle(title: '招待コードを入力'),
              CustomTextField(
                hintText: '招待コード',
                controller: roomCodeController,
                textChange: (text) => roomCode.value = text,
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                text: '保存',
                onTaped: () async {
                  try {
                    // 招待コードのバリデーション
                    final validMessage =
                        Validator.validatePrice(value: roomCode.value);
                    if (validMessage != null) {
                      final snackbar = CustomSnackBar(
                        context,
                        msg: validMessage,
                        color: Colors.red,
                      );
                      scaffoldMessenger.showSnackBar(snackbar);
                      return;
                    }

                    ownerRoomName.value = await ref
                        .read(roomRepositoryProvider)
                        .readRoomName(roomCode: roomCode.value);
                    ref.read(userInfoProvider.notifier).updateUser(
                        uid: ref.watch(uidProvider),
                        newRoomCode: roomCode.value);
                    await ref.read(roomMemberProvider.notifier).joinRoom(
                          roomCode: roomCode.value,
                          userName: userData!.userName,
                          imgURL: userData.imgURL,
                        );
                    // 各Stateを更新
                    ref.invalidate(roomCodeProvider);
                    ref.read(userInfoProvider.notifier).readUser();

                    Navigator.popUntil(
                        context, (Route<dynamic> route) => route.isFirst);
                    final snackbar = CustomSnackBar(
                      context,
                      msg: '【${ownerRoomName.value}】に参加しました！',
                    );
                    scaffoldMessenger.showSnackBar(snackbar);
                  } catch (e) {
                    logger.e(e.toString());
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
