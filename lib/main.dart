import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:share_kakeibo/impoter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flavorを取得しログ出力
  logger.i('FLAVOR : ${flavor.name}');

  //画面を縦向きに固定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
