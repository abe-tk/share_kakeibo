/// view_model
import 'package:share_kakeibo/view/setting/room_name_page.dart';
import 'package:share_kakeibo/view_model/setting/room_info_view_model.dart';

import '../../view_model/add_event/add_event_view_model.dart';
import '../../view_model/calendar/calendar_view_model.dart';
import '../../view_model/chart/chart_view_model.dart';
import '../../view_model/edit_event/edit_event_view_model.dart';
import '../../view_model/home/home_view_model.dart';
import '../../view_model/memo/memo_view_model.dart';
import '../../view_model/setting/invitation_room_view_model.dart';
import '../../view_model/setting/mail_view_model.dart';
import '../../view_model/setting/participate_room_view_model.dart';
import '../../view_model/setting/profile_view_model.dart';
import '../../view_model/setting/room_info_view_model.dart';
import '../../view_model/setting/room_name_view_model.dart';

/// packages
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
    Future(() async {
      await ref.read(roomInfoViewModel).fetchRoom();
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomInfoModel = ref.watch(roomInfoViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOM情報',
          style: TextStyle(color: Color(0xFF725B51)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF725B51)),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    title: Text('【${roomInfoModel.roomName ?? ''}】\nから退出しますか？'),
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
                            ref.read(roomInfoViewModel).judgeOwner();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  title: Text('【${roomInfoModel.name ?? ''}】が登録した収支データは削除されますが、よろしいですか？'),
                                  actions: [
                                    TextButton(
                                      child: const Text("Cancel"),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    TextButton(
                                      child: const Text("OK"),
                                      onPressed: () async {
                                        try {
                                          ref.read(roomInfoViewModel).exitRoom();

                                          //Memo
                                          ref.read(memoViewModelProvider).fetchMemo();
                                          //Home
                                          ref.read(homeViewModelProvider).assetsCalc();
                                          //Calendar
                                          await ref.read(calendarViewModelProvider).fetchRoomCode();
                                          ref.read(calendarViewModelProvider).fetchEvent();
                                          //Chart
                                          ref.read(chartViewModelProvider).calc();
                                          //AddEvent
                                          await ref.read(addEventViewModelProvider).setPaymentUser();
                                          ref.read(addEventViewModelProvider).fetchPaymentUser();
                                          //EditEvent
                                          ref.read(editEventViewModel).fetchPaymentUser();
                                          //Profile
                                          ref.read(profileViewModel).fetchProfile();
                                          //Mail
                                          ref.read(emailViewModel).fetchEmail();
                                          //RoomInfo
                                          ref.read(roomInfoViewModel).fetchRoom();
                                          //RoomName
                                          ref.read(roomNameViewModel).fetchRoomName();
                                          //Invitation
                                          ref.read(invitationRoomViewModel).fetchRoomCode();
                                          //Participation
                                          ref.read(participateRoomViewModel).fetchUser();

                                          Navigator.popUntil(context,
                                                  (Route<dynamic> route) => route.isFirst);

                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text('Roomから退出しました'),
                                            ),
                                          );

                                        } catch (e) {
                                          final snackBar = SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(e.toString()),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } catch (e) {
                            final snackBar = SnackBar(
                              backgroundColor: Colors.red,
                              content: Text(e.toString()),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                child: const Text(
                  'ROOM名',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(
                  Icons.meeting_room,
                  color: Color(0xFF725B51),
                ),
                title: Text(roomInfoModel.roomName ?? ''),
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
                child: const Text(
                  'ROOMのメンバー',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Divider(),
              ListView.builder(
                shrinkWrap: true,
                itemCount: roomInfoModel.roomMemberList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                        roomInfoModel.roomMemberList[index].imgURL,
                      ),
                    ),
                    title: Text(roomInfoModel.roomMemberList[index].userName),
                    subtitle:
                        (roomInfoModel.roomMemberList[index].owner == true)
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
