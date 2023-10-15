import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class RoomNamePage extends HookConsumerWidget {
  const RoomNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomNameState = ref.watch(roomNameProvider).whenOrNull(
          data: (data) => data,
        );
    final roomName = useState(roomNameState);

    final roomNameController = useTextEditingController(text: roomNameState);

    final roomCode = ref.watch(roomCodeProvider).whenOrNull(
          data: (data) => data,
        );

    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Roomの名前を編集'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SubTitle(title: 'Room名'),
              CustomTextField(
                hintText: 'Room名を入力してください',
                controller: roomNameController,
                textChange: (text) => roomName.value = text,
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                text: '保存',
                onTaped: () async {
                  try {
                    // ルーム名のバリデーション
                    // TODO(takuro): nullの場合の記述を修正
                    final validMessage =
                        Validator.validateRoomName(value: roomName.value ?? '');
                    if (validMessage != null) {
                      final snackbar = CustomSnackBar(
                        context,
                        msg: validMessage,
                        color: Colors.red,
                      );
                      scaffoldMessenger.showSnackBar(snackbar);
                      return;
                    }

                    await ref.read(roomNameProvider.notifier).updateRoomName(
                          roomCode: roomCode!,
                          newRoomName: roomName.value!,
                        );
                    Navigator.of(context).pop();
                    final snackbar = CustomSnackBar(
                      context,
                      msg: 'Room名を変更しました',
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
