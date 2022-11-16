import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '設定',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                '個人設定',
                style: TextStyle(
                  color: detailTextColor,
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: dividerColor,
            ),
            ListTile(
              title: const Text('プロフィール'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/profilePage');
              },
            ),
            // const Divider(),
            ListTile(
              title: const Text('アカウント'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/accountPage');
              },
            ),
            const Divider(),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: Text(
                'ROOM設定',
                style: TextStyle(
                  color: detailTextColor,
                ),
              ),
            ),
            Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: dividerColor,
            ),
            ListTile(
              title: const Text('所属ROOM'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/roomInfoPage');
              },
            ),
            ListTile(
              title: const Text('ROOMに招待する'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigator.pushNamed(context, '/invitationRoomPage');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvitationPage(),
                      fullscreenDialog: true,
                    ));
              },
            ),
            ListTile(
              title: const Text('ROOMに参加する'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigator.pushNamed(context, '/invitationRoomPage');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParticipationPage(),
                      fullscreenDialog: true,
                    ));
              },
            ),
            const Divider(),
            /// 課金機能で設定できるようにする予定
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: const EdgeInsets.all(16),
            //   child: Text(
            //     '家計簿の設定',
            //     style: TextStyle(
            //       color: detailTextColor,
            //     ),
            //   ),
            // ),
            // Divider(
            //   height: 0,
            //   thickness: 1,
            //   indent: 16,
            //   endIndent: 16,
            //   color: dividerColor,
            // ),
            // ListTile(
            //   title: const Text('カテゴリー'),
            //   trailing: const Icon(Icons.chevron_right),
            //   onTap: () {
            //     // Navigator.pushNamed(context, '/roomInfoPage');
            //   },
            // ),
            // ListTile(
            //   title: const Text('支払い元'),
            //   trailing: const Icon(Icons.chevron_right),
            //   onTap: () {
            //     // Navigator.pushNamed(context, '/roomInfoPage');
            //   },
            // ),
            // const Divider(),
          ],
        ),
      ),
    );
  }
}
