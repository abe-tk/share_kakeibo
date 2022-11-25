import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class MyApp extends HookConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // レスポンシブ対応のためflutter_screenUtilを適応
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MaterialApp(
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
          textTheme: GoogleFonts.notoSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        onGenerateRoute: RouteGenerator.generateRoute,
        home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // スプラッシュ画面などに書き換えても良い
              return const SizedBox();
            }
            if (snapshot.hasData && loginState == true) {
              // User が null ではない、つまりサインイン済みのホーム画面へ
              // 各Stateを更新
              ref.read(roomNameProvider.notifier).fetchRoomName();
              ref.read(roomMemberProvider.notifier).fetchRoomMember();
              ref.read(userProvider.notifier).fetchUser();
              ref.read(eventProvider.notifier).setEvent();
              ref.read(memoProvider.notifier).setMemo();
              ref.read(roomCodeProvider.notifier).fetchRoomCode();
              return const BottomNavi();
            }
            // User が null である、つまり未サインインのサインイン画面へ
            return const LoginPage();
          },
        ),
      ),
    );
  }
}