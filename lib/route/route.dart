import 'package:flutter/material.dart';
import 'package:share_kakeibo/components/bottom_navi.dart';
import 'package:share_kakeibo/view/calendar/detail_event_page.dart';
import 'package:share_kakeibo/view/chart/year_chart_page.dart';
import 'package:share_kakeibo/view/event/add_event_page.dart';
import 'package:share_kakeibo/view/setting/setting_page.dart';
import 'package:share_kakeibo/view/setting/personal_setting/email_page.dart';
import 'package:share_kakeibo/view/setting/personal_setting/password_page.dart';
import 'package:share_kakeibo/view/setting/personal_setting/account_page.dart';
import 'package:share_kakeibo/view/setting/personal_setting/profile_page.dart';
import 'package:share_kakeibo/view/setting/room_setting/room_info_page.dart';
import 'package:share_kakeibo/view/setting/room_setting/invitaiton_room_page.dart';

class RouteGenerator {
  static const String homeScreen = '/';
  static const String addIncomeEventPage = '/addIncomeEventPage';
  static const String addSpendingEventPage = '/addSpendingEventPage';
  /// EditEventPageへはCalendarPageから[event]を受け取る必要があるため、CalendarPageからNavigator.pushしている。
  // static const String editEventPage = '/editEventPage';
  static const String settingPage = '/settingPage';
  static const String profilePage = '/profilePage';
  static const String accountPage = '/accountPage';
  static const String emailPage = '/emailPage';
  static const String passwordPage = '/passwordPage';
  static const String roomInfoPage = '/roomInfoPage';
  static const String invitationRoomPage = '/invitationRoomPage';
  static const String detailEventPage = '/detailEventPage';
  static const String yearChartPage = '/yearChartPage';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeScreen:
        return MaterialPageRoute(
          builder: (_) => BottomNavi(),
        );
      case addIncomeEventPage:
        return MaterialPageRoute(
          builder: (_) => const AddEventPage(largeCategory: '収入'),
          fullscreenDialog: true,
        );
      case addSpendingEventPage:
        return MaterialPageRoute(
          builder: (_) => const AddEventPage(largeCategory: '支出'),
          fullscreenDialog: true,
        );
      // case editEventPage:
      //   return MaterialPageRoute(
      //     builder: (_) => EditEventPage(event),
      //     fullscreenDialog: true,
      //   );
      case settingPage:
        return MaterialPageRoute(
          builder: (_) => const SettingPage(),
          fullscreenDialog: true,
        );
      case profilePage:
        return MaterialPageRoute(
          builder: (_) => const ProfilePage(),
          fullscreenDialog: true,
        );
      case accountPage:
        return MaterialPageRoute(
          builder: (_) => const AccountPage(),
          fullscreenDialog: true,
        );
      case emailPage:
        return MaterialPageRoute(
          builder: (_) => const EmailPage(),
          fullscreenDialog: true,
        );
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
      case invitationRoomPage:
        return MaterialPageRoute(
          builder: (_) => const InvitationRoomPage(),
          fullscreenDialog: true,
        );
      case detailEventPage:
        return MaterialPageRoute(
          builder: (_) => const DetailEventPage(),
          fullscreenDialog: true,
        );
      case yearChartPage:
        return MaterialPageRoute(
          builder: (_) => const YearChartPage(),
          fullscreenDialog: true,
        );
      default:
        throw Exception('Route not found');
    }
  }
}
