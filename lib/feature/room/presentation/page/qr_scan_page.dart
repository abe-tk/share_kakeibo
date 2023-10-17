import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share_kakeibo/importer.dart';

class QrScanPage extends StatefulHookConsumerWidget {
  const QrScanPage({Key? key}) : super(key: key);

  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends ConsumerState<QrScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  late String roomName;

  Future<String> setRoomName(String code) async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(code).get();
    final data = snapshot.data();
    return data?['roomName'];
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '二次元バーコードの読み取り'),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;
    final userData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      roomName = await setRoomName((scanData.code).toString());
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Row(
              children: [
                const Icon(Icons.meeting_room),
                const SizedBox(width: 8),
                Text(roomName),
              ],
            ),
            content: const Text('このルームへ参加しますか？'),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                  controller.resumeCamera();
                },
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () async {
                  // ここでjoinRoomの処理
                  try {
                    // 所属ルームのルームコードでなければ、新しいルームコードに更新
                    if (scanData.code == ref.watch(roomCodeProvider).value) {
                      final snackbar = CustomSnackBar(
                        context,
                        msg: '既に【$roomName】に参加しています',
                        color: Colors.red,
                      );
                      scaffoldMessenger.showSnackBar(snackbar);
                      return;
                    }
                    ref.read(userInfoProvider.notifier).updateUser(
                        uid: ref.watch(uidProvider),
                        newRoomCode: (scanData.code).toString());

                    await ref.read(roomMemberProvider.notifier).joinRoom(
                          roomCode: (scanData.code).toString(),
                          userName: userData!.userName,
                          imgURL: userData.imgURL,
                        );

                    // 各Stateを更新
                    ref.invalidate(roomCodeProvider);
                    ref.read(userInfoProvider.notifier).readUser();

                    Navigator.popUntil(
                        context, (Route<dynamic> route) => route.isFirst);
                    final snackbar = CustomSnackBar(
                      context,
                      msg: '【$roomName】に参加しました！',
                    );
                    scaffoldMessenger.showSnackBar(snackbar);
                  } catch (e) {
                    logger.e(e.toString());
                    // 入力したコードでルーム名が読み取れない = 招待コードが存在しない場合
                    // QRを読み込んでいるため、実際には起きえない
                    if (roomName.isEmpty) {
                      final snackbar = CustomSnackBar(
                        context,
                        msg: '入力した招待コードのルームが存在しません',
                        color: Colors.red,
                      );
                      scaffoldMessenger.showSnackBar(snackbar);
                      return;
                    }
                  }
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('no Permission'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
