import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/common_widget/custom_list_tile.dart';
import 'package:share_kakeibo/importer.dart';

class ParticipationPage extends ConsumerWidget {
  const ParticipationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ROOMに参加'),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SubTitle(title: 'QRコード'),
                CustomListTile(
                  title: 'QRコードを読み取る',
                  leading: const Icon(Icons.qr_code_scanner),
                  onTaped: () => Navigator.pushNamed(context, '/qrScanPage'),
                ),
                const SizedBox(height: 16),
                const SubTitle(title: '招待コード'),
                CustomListTile(
                  title: '招待コードを入力する',
                  leading: const Icon(Icons.edit),
                  onTaped: () => Navigator.pushNamed(context, '/inputCodePage'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
