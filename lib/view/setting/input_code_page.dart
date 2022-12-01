import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class InputCodePage extends HookConsumerWidget {
  const InputCodePage({Key? key}) : super(key: key);

  void updateState(WidgetRef ref) {
    // 各Stateを更新
    ref.read(roomCodeProvider.notifier).fetchRoomCode();
    ref.read(roomNameProvider.notifier).fetchRoomName();
    ref.read(roomMemberProvider.notifier).fetchRoomMember();
    ref.read(eventProvider.notifier).setEvent();
    ref.read(memoProvider.notifier).setMemo();
    // Home画面で使用するWidgetの値は、Stateが未取得の状態で計算されてしまうため直接firebaseからデータを読み込む（app起動時のみ）
    ref.read(bpPieChartStateProvider.notifier).bpPieChartFirstCalc(DateTime(DateTime.now().year, DateTime.now().month));
    ref.read(totalAssetsStateProvider.notifier).firstCalcTotalAssets();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCode = useState('');
    final roomCodeController = useState(TextEditingController());
    final ownerRoomName = useState('');
    return Scaffold(
      appBar: ActionAppBar(
        title: 'ROOMに参加する',
        icon: Icons.check,
        iconColor: CustomColor.positiveIconColor,
        function: () async {
          try {
            invitationRoomValidation(roomCode.value);
            ownerRoomName.value = await getRoomNameFire(roomCode.value);
            updateUserRoomCodeFire(roomCode.value);
            joinRoomFire(roomCode.value, ref.watch(userProvider)['userName'], ref.watch(userProvider)['imgURL']);
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
            ],
          ),
        ),
      ),
    );
  }
}
