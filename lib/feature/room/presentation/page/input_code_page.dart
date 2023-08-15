import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class InputCodePage extends HookConsumerWidget {
  const InputCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCode = useState('');
    final roomCodeController = useState(TextEditingController());
    final ownerRoomName = useState('');
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ROOMに参加する',
        icon: Icons.check,
        iconColor: CustomColor.positiveIconColor,
        onTaped: () async {
          try {
            invitationRoomValidation(roomCode.value);
            ownerRoomName.value = await RoomFire().getOwnerRoomNameFire(roomCode.value);
            UserFire().updateUserRoomCodeFire(roomCode.value);
            RoomFire().joinRoomFire(roomCode.value, ref.watch(userProvider)['userName'], ref.watch(userProvider)['imgURL']);
            updateState(ref);
            Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
            positiveSnackBar(context, '【${ownerRoomName.value}】に参加しました！');
          } catch (e) {
            negativeSnackBar(context, e.toString());
          }
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SettingTitle(title: '招待コードを入力'),
              SettingTextField(
                controller: roomCodeController.value,
                suffix: false,
                obscure: false,
                text: '招待コード',
                obscureChange: () {},
                textChange: (text) =>  roomCode.value = text,
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
