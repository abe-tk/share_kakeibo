// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/room/room_member_state.dart';
import 'package:share_kakeibo/state/room/room_name_state.dart';
import 'package:share_kakeibo/state/event/event_state.dart';
// view_model
import 'package:share_kakeibo/view_model/home/widgets/bp_pie_chart_view_model.dart';
import 'package:share_kakeibo/view_model/home/widgets/total_assets_view_model.dart';
import 'package:share_kakeibo/view_model/calendar/calendar_view_model.dart';
import 'package:share_kakeibo/view_model/chart/widget/income_category_pie_chart_view_model.dart';
import 'package:share_kakeibo/view_model/chart/widget/spending_category_pie_chart_view_model.dart';
import 'package:share_kakeibo/view_model/chart/widget/income_user_pie_chart_view_model.dart';
import 'package:share_kakeibo/view_model/chart/widget/spending_user_pie_chart_view_model.dart';
import 'package:share_kakeibo/view_model/memo/memo_view_model.dart';
import 'package:share_kakeibo/view_model/setting/room_setting/participate_room_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ParticipateRoomPage extends StatefulHookConsumerWidget {
  const ParticipateRoomPage({Key? key}) : super(key: key);

  @override
  _ParticipateRoomPageState createState() => _ParticipateRoomPageState();
}

class _ParticipateRoomPageState extends ConsumerState<ParticipateRoomPage> {

  @override
  Widget build(BuildContext context) {
    final participationRoomViewModelNotifier = ref.watch(participationRoomViewModelProvider.notifier);
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
                await participationRoomViewModelNotifier.joinRoom();

                // 収支円グラフの再計算
                ref.read(bpPieChartViewModelProvider.notifier).bpPieChartCalc();
                // 総資産額の再計算
                ref.read(totalAssetsViewModelProvider.notifier).calcTotalAssets();
                // カレンダーのイベントを更新
                ref.read(eventProvider.notifier).setEvent();
                // ref.read(calendarViewModelProvider.notifier).fetchCalendarEvent();
                // 統計の円グラフを更新
                ref.read(incomeCategoryPieChartViewModelStateProvider.notifier).incomeCategoryChartCalc();
                ref.read(incomeUserPieChartViewModelStateProvider.notifier).incomeUserChartCalc();
                ref.read(spendingCategoryPieChartViewModelStateProvider.notifier).spendingCategoryChartCalc();
                ref.read(spendingUserPieChartViewModelStateProvider.notifier).spendingUserChartCalc();
                // メモの更新
                ref.read(memoViewModelProvider.notifier).fetchMemo();
                // roomNameの更新
                ref.read(roomNameProvider.notifier).fetchRoomName();
                // roomMemberの更新
                ref.read(roomMemberProvider.notifier).fetchRoomMember();

                Navigator.popUntil(context,
                        (Route<dynamic> route) => route.isFirst);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: positiveSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: Text('【${participationRoomViewModelNotifier.ownerRoomName}】に参加しました！'),
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
                    controller: participationRoomViewModelNotifier.roomCodeController,
                    decoration: const InputDecoration(
                      hintText: '招待コード',
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      participationRoomViewModelNotifier.setRoomCode(text);
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
