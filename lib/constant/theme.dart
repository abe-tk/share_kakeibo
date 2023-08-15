import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_kakeibo/impoter.dart';

class CustomTheme {

  static AppBarTheme appBarTheme = const AppBarTheme(
    // backgroundColor: CustomColor.appBarBackgroundColor,
    backgroundColor: Color(0xFFF9F9F9),
    centerTitle: true,
  );

  static BottomNavigationBarThemeData bottomNavigationBarThemeData = const BottomNavigationBarThemeData(
    backgroundColor: CustomColor.bnBackGroundColor,
    selectedItemColor: CustomColor.bnSelectedItemColor,
    unselectedItemColor: CustomColor.bnUnSelectedItemColor,
    type: BottomNavigationBarType.fixed,
  );

  static FloatingActionButtonThemeData floatingActionButtonThemeData = const FloatingActionButtonThemeData(
    backgroundColor: CustomColor.fabBackGroundColor,
  );

  static ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      primary: CustomColor.ebPrimaryColor,
      side: const BorderSide(
        color: CustomColor.ebBorderSideColor,
        width: 1,
      ),
    ),
  );

  static ToggleButtonsThemeData toggleButtonsThemeData = ToggleButtonsThemeData(
    fillColor: CustomColor.tbFillColor,
    borderWidth: 2,
    borderColor: CustomColor.tbBorderColor,
    selectedColor: CustomColor.tbSelectedColor,
    selectedBorderColor: CustomColor.tbBorderColor,
    borderRadius: BorderRadius.circular(10),
  );

  static ThemeData themeData(BuildContext context) {
    return ThemeData(
      primarySwatch: CustomColor.customPrimarySwatch,
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: bottomNavigationBarThemeData,
      floatingActionButtonTheme: floatingActionButtonThemeData,
      elevatedButtonTheme: elevatedButtonThemeData,
      toggleButtonsTheme: toggleButtonsThemeData,
      indicatorColor: CustomColor.indicatorColor,
      dividerColor: CustomColor.dividerColor,

      textTheme: GoogleFonts.notoSansTextTheme(
        Theme.of(context).textTheme,
      ),
    );
  }

}

