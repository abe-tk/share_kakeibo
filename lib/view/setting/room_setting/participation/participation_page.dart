import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_kakeibo/impoter.dart';

class ParticipationPage extends ConsumerWidget {
  const ParticipationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ROOMに参加',
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
                  'QRコード',
                  style: TextStyle(color: detailTextColor),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.qr_code_scanner),
                title: const Text('QRコードを読み取る'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrScanPage(),
                        fullscreenDialog: true,
                      ));
                },
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  '招待コード',
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
                      child: const InputCodePage(),
                      type: PageTransitionType.rightToLeft,
                      duration: const Duration(milliseconds: 150),
                      reverseDuration: const Duration(milliseconds: 150),
                    ),
                  );
                  ref.read(inputCodeViewModelProvider.notifier).clearRoomCode();
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
