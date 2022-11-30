import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DefaultAppBar(title: '設定'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingTitle(title: '個人設定'),
            SettingItem(
              title: 'プロフィール',
              function: () => Navigator.pushNamed(context, '/profilePage'),
            ),
            SettingItem(
              title: 'アカウント',
              function: () => Navigator.pushNamed(context, '/accountPage'),
            ),
            const Divider(),
            const SettingTitle(title: 'ROOM設定'),
            SettingItem(
              title: '所属ROOM',
              function: () => Navigator.pushNamed(context, '/roomInfoPage'),
            ),
            SettingItem(
              title: 'ROOMに招待する',
              function: () => Navigator.pushNamed(context, '/invitationPage'),
            ),
            SettingItem(
              title: 'ROOMに参加する',
              function: () => Navigator.pushNamed(context, '/participationPage'),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
