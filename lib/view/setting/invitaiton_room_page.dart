/// view
import 'package:share_kakeibo/view/setting/participate_room_page.dart';

/// view_model
import 'package:share_kakeibo/view_model/setting/invitation_room_view_model.dart';
import 'package:share_kakeibo/view_model/setting/participate_room_view_model.dart';

/// packages
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
    Future(() async {
      await ref.read(invitationRoomViewModel).fetchRoomCode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invitationRoomModel = ref.watch(invitationRoomViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOMに招待・参加',
          style: TextStyle(color: Color(0xFF725B51)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF725B51)),
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
                  'ROOMへの招待コード',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.copy),
                title: Text(invitationRoomModel.roomCode ?? ''),
                subtitle: const Text('タップしてコピー'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: "${invitationRoomModel.roomCode}"));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('招待コードをコピーしました！'),
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
                  '他のROOMへ参加する',
                  style: TextStyle(color: Colors.grey),
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
                  ref.read(participateRoomViewModel).clearRoomCode();
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
