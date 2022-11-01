// constant
import 'package:share_kakeibo/constant/colors.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
                'Room設定',
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
              title: const Text('ROOMに招待・参加'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pushNamed(context, '/invitationRoomPage');
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
