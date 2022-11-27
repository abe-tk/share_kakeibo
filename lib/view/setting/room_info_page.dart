import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_kakeibo/impoter.dart';

class RoomInfoPage extends HookConsumerWidget {
  const RoomInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomNameState = ref.watch(roomNameProvider);
    final roomMemberState = ref.watch(roomMemberProvider);
    final userState = ref.watch(userProvider);
    return Scaffold(
      appBar: ActionAppBar(
        title: 'ROOM情報',
        icon: Icons.logout,
        iconColor: Colors.black,
        function: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) {
              return AlertDialog(
                title: Text('【$roomNameState】\nから退出しますか？'),
                actions: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () async {
                      try {
                        Navigator.of(context).pop();
                        if (uid == ref.watch(roomCodeProvider)) {
                          throw 'RoomOwnerは退出できません';
                        }
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(
                                  '【${userState['userName']}】が登録した収支データは削除されますが、よろしいですか？'),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () async {
                                    try {
                                      await exitRoomFire(ref.watch(roomCodeProvider), ref.watch(userProvider)['userName']);
                                      // 各Stateを更新
                                      ref.read(roomCodeProvider.notifier).fetchRoomCode();
                                      ref.read(roomNameProvider.notifier).fetchRoomName();
                                      ref.read(roomMemberProvider.notifier).fetchRoomMember();
                                      ref.read(eventProvider.notifier).setEvent();
                                      ref.read(memoProvider.notifier).setMemo();
                                      // Home画面で使用するWidgetの値は、Stateが未取得の状態で計算されてしまうため直接firebaseからデータを読み込む（app起動時のみ）
                                      ref.read(bpPieChartStateProvider.notifier).bpPieChartFirstCalc(DateTime(DateTime.now().year, DateTime.now().month));
                                      ref.read(totalAssetsStateProvider.notifier).firstCalcTotalAssets();
                                      Navigator.popUntil(
                                          context,
                                              (Route<dynamic> route) =>
                                          route.isFirst);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: negativeSnackBarColor,
                                          behavior: SnackBarBehavior.floating,
                                          content: const Text('Roomから退出しました'),
                                        ),
                                      );
                                    } catch (e) {
                                      final snackBar = SnackBar(
                                        backgroundColor: negativeSnackBarColor,
                                        behavior: SnackBarBehavior.floating,
                                        content: Text(e.toString()),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: negativeSnackBarColor,
                          behavior: SnackBarBehavior.floating,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context)
                            .showSnackBar(snackBar);
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'ROOM名',
                  style: TextStyle(color: detailTextColor),
                ),
              ),
              const Divider(),
              ListTile(
                leading: Icon(
                  Icons.meeting_room,
                  color: roomNameIconColor,
                ),
                title: Text(roomNameState),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const RoomNamePage(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 150),
                      reverseDuration: const Duration(milliseconds: 150),
                    ),
                  );
                },
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  'ROOMのメンバー',
                  style: TextStyle(color: detailTextColor),
                ),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: roomMemberState.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        roomMemberState[index].imgURL,
                      ),
                    ),
                    title: Text(roomMemberState[index].userName),
                    subtitle: (roomMemberState[index].owner == true)
                        ? const Text('owner')
                        : const Text(''),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
