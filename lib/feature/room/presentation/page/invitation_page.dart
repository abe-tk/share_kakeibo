import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_kakeibo/importer.dart';

class InvitationPage extends ConsumerWidget {
  const InvitationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomCode = ref.watch(roomCodeProvider);
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    void showQrCode() {
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
                  padding: EdgeInsets.only(top: 10, left: 60, right: 60),
                  child: Divider(thickness: 3),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: CustomColor.bdBorderSideColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: roomCode.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => const Text('error'),
                    data: (data) => QrImage(
                      data: data,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'ROOMに招待'),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SubTitle(title: 'QRコード'),
                CustomListTile(
                  title: 'QRコードを表示する',
                  leading: const Icon(Icons.qr_code),
                  onTaped: () => showQrCode(),
                ),
                const SizedBox(height: 16),
                const SubTitle(title: '招待コード'),
                roomCode.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => const Text('error'),
                  data: (data) => CustomListTile(
                    title: data,
                    leading: const Icon(Icons.copy),
                    subTitle: 'タップしてコピー',
                    isTrailing: false,
                    onTaped: () {
                      Clipboard.setData(ClipboardData(text: data));
                      final snackbar = CustomSnackBar(
                        context,
                        msg: '招待コードをコピーしました！',
                      );
                      scaffoldMessenger.showSnackBar(snackbar);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
