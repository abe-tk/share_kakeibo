import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class ParticipationPage extends ConsumerWidget {
  const ParticipationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'ROOMに参加'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SettingTitle(title: 'QRコード'),
              SettingIconItem(
                icon: Icons.qr_code_scanner,
                title: 'QRコードを読み取る',
                function: () => Navigator.pushNamed(context, '/qrScanPage'),
              ),
              const Divider(),
              const SettingTitle(title: '招待コード'),
              SettingIconItem(
                icon: Icons.edit,
                title: '招待コードを入力する',
                function: () => Navigator.pushNamed(context, '/inputCodePage'),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
