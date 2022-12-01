import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_kakeibo/impoter.dart';

class InvitationPage extends ConsumerWidget {
  const InvitationPage({Key? key}) : super(key: key);

  void showQrCode(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
      ),
      builder: (BuildContext context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 10,left: 60, right: 60),
                child: Divider(thickness: 3),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColor.bdBorderSideColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: QrImage(
                  data: ref.watch(roomCodeProvider),
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'ROOMに招待'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SettingTitle(title: 'QRコード'),
              SettingIconItem(
                icon: Icons.qr_code,
                title: 'QRコードを表示する',
                function: () => showQrCode(context, ref),
              ),
              const Divider(),
              const SettingTitle(title: '招待コード'),
              ListTile(
                leading: const Icon(Icons.copy),
                title: Text(ref.watch(roomCodeProvider), style: const TextStyle(fontSize: 16)),
                subtitle: const Text('タップしてコピー'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: ref.watch(roomCodeProvider)));
                  appSnackBar(context, '招待コードをコピーしました！');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
