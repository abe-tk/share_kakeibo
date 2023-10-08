import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/custom_list_tile.dart';
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

    final roomCode =
        ref.watch(roomCodeProvider(ref.watch(uidProvider))).whenOrNull(
              data: (data) => data,
            );

    void checkExitRoom(Function function) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomAlertDialog(
              title: '【${ref.watch(roomNameProvider)}】\nから退出しますか？',
              subTitle: '',
              function: () {
                try {
                  exitRoomValidation(ref.watch(uidProvider), roomCode!);
                  Navigator.of(context).pop();
                  function();
                } catch (e) {
                  Navigator.of(context).pop();
                  negativeSnackBar(context, e.toString());
                }
              });
        },
      );
    }

    void checkAgainExitRoom() {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return CustomAlertDialog(
            title: '【${userData!.userName}】が登録した収支データは削除されますが、よろしいですか？',
            subTitle: '',
            function: () async {
              try {
                // await RoomFire().exitRoomFire(
                //     ref.watch(roomCodeProvider), userData.userName);
                await ref.read(roomMemberProvider.notifier).exitRoom(
                      roomCode: roomCode!,
                      userName: userData.userName,
                    );
                // 各Stateを更新
                ref.invalidate(roomCodeProvider(ref.watch(uidProvider)));
                ref.read(userInfoProvider.notifier).readUser();
                ref
                    .read(totalAssetsStateProvider.notifier)
                    .firstCalcTotalAssets(
                      ref.watch(uidProvider),
                    );

                Navigator.popUntil(
                    context, (Route<dynamic> route) => route.isFirst);
                negativeSnackBar(context, 'Roomから退出しました');
              } catch (e) {
                negativeSnackBar(context, e.toString());
              }
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title: 'ROOM情報',
        icon: Icons.logout,
        iconColor: CustomColor.defaultIconColor,
        onTaped: () {
          checkExitRoom(() => checkAgainExitRoom());
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
