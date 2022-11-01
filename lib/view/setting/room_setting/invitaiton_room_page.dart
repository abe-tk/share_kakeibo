// constant
import 'package:share_kakeibo/constant/colors.dart';
// view
import 'package:share_kakeibo/view/setting/room_setting/participate_room_page.dart';
// view_model
import 'package:share_kakeibo/view_model/setting/room_setting/invitation_room_view_model.dart';
import 'package:share_kakeibo/view_model/setting/room_setting/participate_room_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class InvitationRoomPage extends StatefulHookConsumerWidget {
  const InvitationRoomPage({Key? key}) : super(key: key);

  @override
  _InvitationRoomPageState createState() => _InvitationRoomPageState();
}

class _InvitationRoomPageState extends ConsumerState<InvitationRoomPage> {

  @override
  void initState() {
    super.initState();
    ref.read(invitationRoomViewModelProvider.notifier).fetchRoomInfo();
  }

  @override
  Widget build(BuildContext context) {
    final invitationRoomViewModelState = ref.watch(invitationRoomViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOMに招待・参加',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
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
                  'ROOMへの招待コード',
                  style: TextStyle(color: detailTextColor),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.copy),
                title: Text(invitationRoomViewModelState, style: const TextStyle(fontSize: 16),),
                subtitle: const Text('タップしてコピー'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: invitationRoomViewModelState));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('招待コードをコピーしました！'),
                      behavior: SnackBarBehavior.floating,
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
                  '他のROOMへ参加する',
                  style: TextStyle(color: detailTextColor),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('招待コードを入力する'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      child: const ParticipateRoomPage(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 150),
                      reverseDuration: const Duration(milliseconds: 150),
                    ),
                  );
                  ref.read(participationRoomViewModelProvider.notifier).clearRoomCode();
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
