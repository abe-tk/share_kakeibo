/// components
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/components/auth_fire.dart';
import 'components/theme.dart';
import 'package:share_kakeibo/components/bottom_navi.dart';

/// view
import 'package:share_kakeibo/view/login/login_page.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("en"),
        Locale("ja"),
      ],
      theme: ThemeData(
        primarySwatch: customPrimarySwatch,
        scaffoldBackgroundColor: customScaffoldBackgroundColor,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // スプラッシュ画面などに書き換えても良い
            return const SizedBox();
          }
          if (snapshot.hasData && loginState == true) {
            // User が null ではない、つまりサインイン済みのホーム画面へ
            return BottomNavi();
          }
          // User が null である、つまり未サインインのサインイン画面へ
          return const LoginPage();
        },
      ),
    );
  }
}
