import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';
import 'package:share_kakeibo/util/shared_preferences/data/shared_preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/firebase/dev/firebase_options.dart' as dev;
import 'config/firebase/prod/firebase_options.dart' as prod;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Flavorを取得しログ出力
  const flavor = String.fromEnvironment('flavor');
  logger.i('FLAVOR : $flavor');

  // Firebaseを初期化
  final firebaseApp =
      await Firebase.initializeApp(options: getFirebaseOptions());
  logger.i('Initialized Firebase project : ${firebaseApp.options.projectId}');

  //画面を縦向きに固定
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp();

  // SharedPreferencesの初期化
  late final SharedPreferences sharedPreferences;
  await Future.wait([
    Future(() async {
      sharedPreferences = await SharedPreferences.getInstance();
    }),
  ]);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesRepositoryProvider.overrideWithValue(
          SharedPreferencesRepository(sharedPreferences),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

// ビルドモード毎にfirebaseの環境分けをする
FirebaseOptions getFirebaseOptions() {
  switch (flavor) {
    case Flavor.dev:
      return dev.DefaultFirebaseOptions.currentPlatform;
    case Flavor.prod:
      return prod.DefaultFirebaseOptions.currentPlatform;
  }
}
