/// view
import 'package:share_kakeibo/view/setting/profile_page.dart';
import 'package:share_kakeibo/view/setting/mail_page.dart';
import 'package:share_kakeibo/view/setting/room_info_page.dart';
import 'package:share_kakeibo/view/setting/invitaiton_room_page.dart';

/// view_model
import 'package:share_kakeibo/view_model/setting/profile_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '設定',
          style: TextStyle(color: Color(0xFF725B51)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF725B51)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: const Text(
                '個人設定',
                style: TextStyle(
                  color: Color.fromRGBO(65, 65, 65, 0.8),
                ),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Colors.grey,
            ),
            ListTile(
              title: const Text('プロフィール'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const ProfilePage(),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 150),
                    reverseDuration: const Duration(milliseconds: 150),
                  ),
                );
                ref.read(profileViewModel).clearImgFile();
              },
            ),
            // const Divider(),
            ListTile(
              title: const Text('メールアドレス'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const MailPage(),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 150),
                    reverseDuration: const Duration(milliseconds: 150),
                  ),
                );
              },
            ),
            const Divider(),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: const Text(
                'Room設定',
                style: TextStyle(
                  color: Color.fromRGBO(65, 65, 65, 0.8),
                ),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Colors.grey,
            ),
            ListTile(
              title: const Text('所属ROOM'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const RoomInfoPage(),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 150),
                    reverseDuration: const Duration(milliseconds: 150),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('ROOMに招待・参加'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    child: const InvitationRoomPage(),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 150),
                    reverseDuration: const Duration(milliseconds: 150),
                  ),
                );
              },
            ),
            const Divider(),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.all(16),
              child: const Text(
                'ログイン',
                style: TextStyle(
                  color: Color.fromRGBO(65, 65, 65, 0.8),
                ),
              ),
            ),
            const Divider(
              height: 0,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Colors.grey,
            ),
            GestureDetector(
              child: ListTile(
                title: const Text('ログアウト'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return AlertDialog(
                        title: const Text("ログアウトしますか？"),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("OK"),
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.popUntil(context,
                                      (Route<dynamic> route) => route.isFirst);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
