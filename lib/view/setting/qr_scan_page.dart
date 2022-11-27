import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:share_kakeibo/impoter.dart';

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
    final snapshot = await FirebaseFirestore.instance.collection('users').doc(code).get();
    final data = snapshot.data();
    return data?['roomName'];
  }

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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
      appBar: const DefaultAppBar(title: 'QR読み取り'),
      body: _buildQrView(context),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    // final ownerRoomName = useState('');
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      // print(scanData.code);
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
                    updateUserRoomCodeFire((scanData.code).toString());
                    joinRoomFire((scanData.code).toString(), ref.watch(userProvider)['userName'], ref.watch(userProvider)['imgURL']);
                    // 各Stateを更新
                    ref.read(roomCodeProvider.notifier).fetchRoomCode();
                    ref.read(roomNameProvider.notifier).fetchRoomName();
                    ref.read(roomMemberProvider.notifier).fetchRoomMember();
                    ref.read(eventProvider.notifier).setEvent();
                    ref.read(memoProvider.notifier).setMemo();
                    // Home画面で使用するWidgetの値は、Stateが未取得の状態で計算されてしまうため直接firebaseからデータを読み込む（app起動時のみ）
                    ref.read(bpPieChartStateProvider.notifier).bpPieChartFirstCalc(DateTime(DateTime.now().year, DateTime.now().month));
                    ref.read(totalAssetsStateProvider.notifier).firstCalcTotalAssets();
                    Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: positiveSnackBarColor,
                        behavior: SnackBarBehavior.floating,
                        content: Text('【$roomName】に参加しました！'),
                      ),
                    );
                  } catch (e) {
                    final snackBar = SnackBar(
                      backgroundColor: negativeSnackBarColor,
                      behavior: SnackBarBehavior.floating,
                      content: Text(e.toString()),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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