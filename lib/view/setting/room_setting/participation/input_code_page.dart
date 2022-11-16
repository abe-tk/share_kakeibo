import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class InputCodePage extends ConsumerWidget {
  const InputCodePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inputCodeViewModelNotifier = ref.watch(inputCodeViewModelProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOMに参加する',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await inputCodeViewModelNotifier.joinRoom();
                // 各Stateを更新
                ref.read(roomNameProvider.notifier).fetchRoomName();
                ref.read(roomMemberProvider.notifier).fetchRoomMember();
                ref.read(eventProvider.notifier).setEvent();
                ref.read(memoProvider.notifier).setMemo();
                // Home画面で使用するWidgetの値は、Stateが未取得の状態で計算されてしまうため直接firebaseからデータを読み込む（app起動時のみ）
                ref.read(bpPieChartStateProvider.notifier).bpPieChartFirstCalc(DateTime(DateTime.now().year, DateTime.now().month));
                ref.read(totalAssetsStateProvider.notifier).firstCalcTotalAssets();
                Navigator.popUntil(context,
                        (Route<dynamic> route) => route.isFirst);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: positiveSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: Text('【${inputCodeViewModelNotifier.ownerRoomName}】に参加しました！'),
                  ),
                );
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: negativeSnackBarColor,
                  behavior: SnackBarBehavior.floating,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(Icons.check, color: positiveIconColor,),
          ),
        ],
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
                  '招待コードを入力',
                  style: TextStyle(color: detailIconColor),
                ),
              ),
              const Divider(),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListTile(
                  title: TextField(
                    textAlign: TextAlign.left,
                    controller: inputCodeViewModelNotifier.roomCodeController,
                    decoration: const InputDecoration(
                      hintText: '招待コード',
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      inputCodeViewModelNotifier.setRoomCode(text);
                    },
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
