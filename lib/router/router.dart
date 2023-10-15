import 'package:flutter/material.dart';
import 'package:share_kakeibo/importer.dart';

class RouteGenerator {
  // EditEventPageへはCalendarPageから[event]を受け取る必要があるため、CalendarPageからNavigator.pushしている。
  static const String homeScreen = '/';
  static const String addIncomeEventPage = '/addIncomeEventPage';
  static const String addSpendingEventPage = '/addSpendingEventPage';
  static const String settingPage = '/settingPage';
  // static const String profilePage = '/profilePage';
  static const String accountPage = '/accountPage';
  // static const String emailPage = '/emailPage';
  static const String passwordPage = '/passwordPage';
  static const String roomInfoPage = '/roomInfoPage';
  static const String invitationPage = '/invitationPage';
  static const String participationPage = '/participationPage';
  static const String roomNamePage = '/roomNamePage';
  static const String qrScanPage = '/qrScanPage';
  static const String inputCodePage = '/inputCodePage';
  static const String registerPage = '/registerPage';
  static const String resetPasswordPage = '/resetPasswordPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => const RootPage(),
        );
      case addIncomeEventPage:
        return MaterialPageRoute(
          builder: (_) => const UpsertEventPage(largeCategory: '収入'),
          fullscreenDialog: true,
        );
      case addSpendingEventPage:
        return MaterialPageRoute(
          builder: (_) => const UpsertEventPage(largeCategory: '支出'),
          fullscreenDialog: true,
        );
      case settingPage:
        return MaterialPageRoute(
          builder: (_) => const SettingPage(),
          fullscreenDialog: true,
        );
      // case profilePage:
      //   return MaterialPageRoute(
      //     builder: (_) => const ProfilePage(),
      //     fullscreenDialog: true,
      //   );
      case accountPage:
        return MaterialPageRoute(
          builder: (_) => const AccountPage(),
          fullscreenDialog: true,
        );
      // case emailPage:
      //   return MaterialPageRoute(
      //     builder: (_) => const EmailPage(),
      //     fullscreenDialog: true,
      //   );
      case passwordPage:
        return MaterialPageRoute(
          builder: (_) => const PasswordPage(),
          fullscreenDialog: true,
        );
      case roomInfoPage:
        return MaterialPageRoute(
          builder: (_) => const RoomInfoPage(),
          fullscreenDialog: true,
        );
      case registerPage:
        return MaterialPageRoute(
          builder: (_) => const RegisterPage(),
          fullscreenDialog: true,
        );
      case resetPasswordPage:
        return MaterialPageRoute(
          builder: (_) => const ResetPasswordPage(),
          fullscreenDialog: true,
        );
      case invitationPage:
        return MaterialPageRoute(
          builder: (_) => const InvitationPage(),
          fullscreenDialog: true,
        );
      case participationPage:
        return MaterialPageRoute(
          builder: (_) => const ParticipationPage(),
          fullscreenDialog: true,
        );
      case roomNamePage:
        return MaterialPageRoute(
          builder: (_) => const RoomNamePage(),
          fullscreenDialog: true,
        );
      case qrScanPage:
        return MaterialPageRoute(
          builder: (_) => const QrScanPage(),
          fullscreenDialog: true,
        );
      case inputCodePage:
        return MaterialPageRoute(
          builder: (_) => const InputCodePage(),
          fullscreenDialog: true,
        );
      default:
        throw Exception('Route not found');
    }
  }
}
