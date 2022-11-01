// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/price/total_assets_state.dart';
import 'package:share_kakeibo/state/event/calendar_event_state.dart';
import 'package:share_kakeibo/state/pie_chart/bp_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/income_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/income_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/room/room_name_state.dart';
import 'package:share_kakeibo/state/room/room_member_state.dart';
import 'package:share_kakeibo/state/user/user_state.dart';
// view
import 'package:share_kakeibo/view/setting/room_setting/room_name_page.dart';
// view_model
import 'package:share_kakeibo/view_model/setting/room_setting/room_info_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class RoomInfoPage extends StatefulHookConsumerWidget {
  const RoomInfoPage({Key? key}) : super(key: key);

  @override
  _RoomInfoPageState createState() => _RoomInfoPageState();
}

class _RoomInfoPageState extends ConsumerState<RoomInfoPage> {
  @override
  void initState() {
    super.initState();
    ref.read(roomInfoViewModelProvider.notifier).fetchRoomInfo();
  }

  @override
  Widget build(BuildContext context) {
    final roomInfoViewModelNotifier = ref.watch(roomInfoViewModelProvider.notifier);
    final roomNameState = ref.watch(roomNameProvider);
    final roomMemberState = ref.watch(roomMemberProvider);
    final userState = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOM情報',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
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
                            roomInfoViewModelNotifier.judgeOwner();
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
                                          await roomInfoViewModelNotifier.exitRoom();
                                          // 収支円グラフの再計算
                                          ref.read(bpPieChartProvider.notifier).bpPieChartCalc();
                                          // 総資産額の再計算
                                          ref.read(totalAssetsProvider.notifier).calcTotalAssets();
                                          // カレンダーのイベントを更新
                                          ref.read(calendarEventProvider.notifier).fetchCalendarEvent();
                                          // 統計の円グラフを更新
                                          ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc();
                                          ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc();
                                          ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc();
                                          ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc();
                                          // roomNameの更新
                                          ref.read(roomNameProvider.notifier).fetchRoomName();
                                          // roomMemberの更新
                                          ref.read(roomMemberProvider.notifier).fetchRoomMember();

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
            icon: const Icon(Icons.logout),
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
