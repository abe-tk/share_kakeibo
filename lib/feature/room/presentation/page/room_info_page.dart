import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class RoomInfoPage extends HookConsumerWidget {
  const RoomInfoPage({Key? key}) : super(key: key);

  void checkExitRoom(BuildContext context, WidgetRef ref, Function function) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AppAlertDialog(
          title: '【${ref.watch(roomNameProvider)}】\nから退出しますか？',
          subTitle: '',
          function: () {
            try {
              exitRoomValidation(ref.watch(roomCodeProvider));
              Navigator.of(context).pop();
              function();
            } catch (e) {
              Navigator.of(context).pop();
              negativeSnackBar(context, e.toString());
            }
          }
        );
      },
    );
  }

  void checkAgainExitRoom(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AppAlertDialog(
          title: '【${ref.watch(userProvider)['userName']}】が登録した収支データは削除されますが、よろしいですか？',
          subTitle: '',
          function: () async {
            try {
              await RoomFire().exitRoomFire(ref.watch(roomCodeProvider), ref.watch(userProvider)['userName']);
              updateState(ref);
              Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
              negativeSnackBar(context, 'Roomから退出しました');
            } catch (e) {
              negativeSnackBar(context, e.toString());
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomNameState = ref.watch(roomNameProvider);
    final roomMemberState = ref.watch(roomMemberProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'ROOM情報',
        icon: Icons.logout,
        iconColor: CustomColor.defaultIconColor,
        onTaped: () {
          checkExitRoom(context, ref, () => checkAgainExitRoom(context, ref));
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SettingTitle(title: 'ROOM名'),
              SettingIconItem(
                icon: Icons.meeting_room,
                title: roomNameState,
                function: () => Navigator.pushNamed(context, '/roomNamePage'),
              ),
              const Divider(),
              const SettingTitle(title: 'ROOMのメンバー'),
              ListView.builder(
                shrinkWrap: true,
                itemCount: roomMemberState.length,
                itemBuilder: (BuildContext context, int index) {
                  return RoomMemberList(
                    imgURL: roomMemberState[index].imgURL,
                    userName: roomMemberState[index].userName,
                    owner: roomMemberState[index].owner,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
