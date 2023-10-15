import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // プロフィール編集画面に渡すUserData
    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    return Scaffold(
      appBar: const CustomAppBar(title: '設定'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SubTitle(title: '個人設定'),
              CustomListTile(
                title: 'プロフィール',
                leading: const Icon(Icons.person),
                // onTaped: () => Navigator.pushNamed(context, '/profilePage'),
                // TODO: routerに含める
                onTaped: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ProfilePage(userData: userData);
                    },
                  ),
                ),
              ),
              CustomListTile(
                title: 'アカウント',
                leading: const Icon(Icons.phone_android),
                onTaped: () => Navigator.pushNamed(context, '/accountPage'),
              ),
              const SizedBox(height: 16),
              const SubTitle(title: 'ROOM設定'),
              CustomListTile(
                title: '所属ROOM',
                leading: const Icon(Icons.door_back_door),
                onTaped: () => Navigator.pushNamed(context, '/roomInfoPage'),
              ),
              CustomListTile(
                title: 'ROOMに招待する',
                leading: const Icon(Icons.mail),
                onTaped: () => Navigator.pushNamed(context, '/invitationPage'),
              ),
              CustomListTile(
                title: 'ROOMに参加する',
                leading: const Icon(Icons.inbox),
                onTaped: () =>
                    Navigator.pushNamed(context, '/participationPage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
