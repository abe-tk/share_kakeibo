import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class RoomNamePage extends HookConsumerWidget {
  const RoomNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomName = useState(ref.watch(roomNameProvider));
    final roomNameController = useState(TextEditingController(text: ref.watch(roomNameProvider)));

    Future<void> changeRooName() async {
      try {
        await ref.watch(roomNameProvider.notifier).changeRoomName(roomName.value);
        Navigator.of(context).pop();
        positiveSnackBar(context, 'Room名を変更しました');
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Roomの名前を編集',
        icon: Icons.check,
        iconColor: CustomColor.positiveIconColor,
        onTaped: () async => changeRooName(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingTitle(title: 'Room名'),
            SettingTextField(
              controller: roomNameController.value,
              suffix: false,
              obscure: false,
              text: 'Room名を入力してください',
              obscureChange: () {},
              textChange: (text) => roomName.value = text,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}