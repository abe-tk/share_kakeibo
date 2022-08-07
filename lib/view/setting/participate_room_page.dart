/// view_model
import 'package:share_kakeibo/view_model/setting/participate_room_view_model.dart';

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

class ParticipateRoomPage extends StatefulHookConsumerWidget {
  const ParticipateRoomPage({Key? key}) : super(key: key);

  @override
  _ParticipateRoomPageState createState() => _ParticipateRoomPageState();
}

class _ParticipateRoomPageState extends ConsumerState<ParticipateRoomPage> {

  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(participateRoomViewModel).fetchUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final participateRoomModel = ref.watch(participateRoomViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOMに参加する',
          style: TextStyle(color: Color(0xFF725B51)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF725B51)),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await participateRoomModel.joinRoom();

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
                  SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('【${participateRoomModel.roomName}】に参加しました！'),
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
            icon: const Icon(Icons.check, color: Colors.green,),
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
                  '招待コードを入力',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Divider(),
              Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ListTile(
                  title: TextField(
                    textAlign: TextAlign.left,
                    controller: participateRoomModel.roomCodeController,
                    decoration: const InputDecoration(
                      hintText: '招待コード',
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      participateRoomModel.setRoomCode(text);
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
