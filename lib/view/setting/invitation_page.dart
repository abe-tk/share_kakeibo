import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_kakeibo/impoter.dart';

class InvitationPage extends ConsumerWidget {
  const InvitationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const DefaultAppBar(title: 'ROOMに招待'),
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
                leading: const Icon(Icons.qr_code),
                title: const Text('QRコードを表示する'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
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
                                border: Border.all(color: Colors.black),
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
                leading: const Icon(Icons.copy),
                title: Text(ref.watch(roomCodeProvider), style: const TextStyle(fontSize: 16),),
                subtitle: const Text('タップしてコピー'),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: ref.watch(roomCodeProvider)));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('招待コードをコピーしました！'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
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
