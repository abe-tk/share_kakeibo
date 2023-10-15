import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  // primarySwatch
  static const int _customPrimarySwatch = 0xFF9E9E9E;
  static const MaterialColor customPrimarySwatch = MaterialColor(
    _customPrimarySwatch,
    <int, Color>{
      50: Color(0xFFF3F3F3),
      100: Color(0xFFE2E2E2),
      200: Color(0xFFCFCFCF),
      300: Color(0xFFBBBBBB),
      400: Color(0xFFADADAD),
      500: Color(_customPrimarySwatch),
      600: Color(0xFF969696),
      700: Color(0xFF8C8C8C),
      800: Color(0xFF828282),
      900: Color(0xFF707070),
    },
  );

  static AppBarTheme appBarTheme = const AppBarTheme(
    backgroundColor: Color(0xFFF9F9F9),
    centerTitle: false,
  );

  static BottomNavigationBarThemeData bottomNavigationBarThemeData =
      const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFFF1F1F1),
    selectedItemColor: Color(0xFF000000),
    unselectedItemColor: Color(0xFF808080),
    type: BottomNavigationBarType.fixed,
  );

  static FloatingActionButtonThemeData floatingActionButtonThemeData =
      const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFFFFF),
  );

  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primarySwatch: customPrimarySwatch,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
      floatingActionButtonTheme: floatingActionButtonThemeData,
      indicatorColor: const Color(0xFF000000),
      dividerColor: const Color(0xFF808080),
      textTheme: GoogleFonts.notoSansTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }
}
