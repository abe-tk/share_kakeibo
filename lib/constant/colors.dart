import 'package:flutter/material.dart';

class CustomColor {

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

  // appBarTheme
  static const appBarBackgroundColor = Color(0xFFEBEBEB);

  // indicatorColor
  static const indicatorColor = Color(0xFF000000);

  // dividerColor
  static const dividerColor = Color(0xFF808080);

  // bottomNavigationBarTheme
  static const bnBackGroundColor = Color(0xFFF1F1F1);
  static const bnSelectedItemColor = Color(0xFF000000);
  static const bnUnSelectedItemColor = Color(0xFF808080);

  // floatingActionButtonTheme
  static const fabBackGroundColor = Color(0xFFFFFFFF);

  // elevatedButtonTheme
  static const ebPrimaryColor = Color(0xFFFFFFFF);
  static const ebBorderSideColor = Color(0xFF000000);

  // toggleButtonsTheme
  static const tbFillColor = Color(0xFFFFFFFF);
  static const tbSelectedColor = Color(0xFF000000);
  static const tbBorderColor = Color(0xFFCFCFCF);

  // drawer
  static const drawerHeaderColor = Color(0xFFEBEBEB);

  // snackBar
  static const sbSuccessColor = Colors.green;
  static const sbFailureColor = Colors.red;

  // textField
  static const tfTextColor = Colors.grey;
  static const tfBorderSideColor = Colors.grey;

  // batchIcon
  static const biTextColor = Colors.white;
  static const biBackGroundColor = Colors.red;

  // icon
  static const positiveIconColor = Colors.green;
  static const negativeIconColor = Colors.red;
  static const detailIconColor = Colors.grey;
  static const defaultIconColor = Colors.black;

  // text
  static const defaultTextColor = Colors.black;
  static const incomeTextColor = Color(0xFF00800D);
  static const spendingTextColor = Color(0xFFFF0000);
  static const detailTextColor = Colors.grey;
  static const pieChartCenterTextColor = Color.fromRGBO(65, 65, 65, 0.8);
  static const pieChartCategoryTextColor = Colors.black54;

  //container
  static const whiteContainerColor = Color(0xFFFFFFFF);

  // boxDecoration
  static const bdColor = Colors.white;
  static const bdShadowColor = Colors.grey;
  static const bdBorderSideColor = Colors.black;

  // Qr
  static const qrBorderColor = Colors.red;

}








