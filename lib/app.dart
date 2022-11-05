// components
import 'package:share_kakeibo/components/bottom_navi.dart';
// constant
import 'package:share_kakeibo/constant/colors.dart';
// firebase
import 'package:share_kakeibo/firebase/auth_fire.dart';
// route
import 'package:share_kakeibo/route/route.dart';
// state
import 'package:share_kakeibo/state/room/room_member_state.dart';
import 'package:share_kakeibo/state/room/room_name_state.dart';
import 'package:share_kakeibo/state/user/user_state.dart';
import 'package:share_kakeibo/state/event/event_state.dart';
import 'package:share_kakeibo/state/memo/memo_state.dart';
// view
import 'package:share_kakeibo/view/login/login_page.dart';
// view_model
import 'package:share_kakeibo/view_model/home/widgets/bp_pie_chart_view_model.dart';
import 'package:share_kakeibo/view_model/home/widgets/total_assets_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            // Home画面で使用するWidgetの値は、Stateが未取得の状態で計算されてしまうため直接firebaseからデータを読み込む（app起動時のみ）
            ref.read(bpPieChartViewModelProvider.notifier).bpPieChartFirstCalc();
            ref.read(totalAssetsViewModelProvider.notifier).firstCalcTotalAssets();
            return const BottomNavi();
          }
          // User が null である、つまり未サインインのサインイン画面へ
          return const LoginPage();
        },
      ),
    );
  }
}