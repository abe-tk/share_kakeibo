import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // SnackBar表示のためののGlobalKey
    final scaffoldKey = ref.watch(scaffoldKeyProvider);

    // authのサービス
    final authService = ref.watch(authServiceProvider);

    // レスポンシブ対応のためflutter_screenUtilを適応
    return MaterialApp(
      scaffoldMessengerKey: scaffoldKey,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("ja"),
      ],
      theme: CustomTheme.themeData(context),
      onGenerateRoute: RouteGenerator.generateRoute,
      home: StreamBuilder<User?>(
        stream: authService.checkSignIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          // Userがnullでなければ（サインイン済み）ホーム画面へ遷移
          if (snapshot.hasData) {
            // 各Stateを更新
            ref.invalidate(roomCodeProvider);
            ref.read(userInfoProvider.notifier).readUser();
            return const RootPage();
          }
          // Userがnullであれば（未サインイン）サインイン画面へ遷移
          return const LoginPage();
        },
      ),
    );
  }
}
