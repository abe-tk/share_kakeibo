import 'package:flutter/material.dart';

class PieData {
  String? title;
  double? percent;
  Color? color;
  PieData({required this.title, required this.percent, required this.color});
}

class ChartData {
  String? category;
  int? price;
  double? percent;
  Color? color;
  IconData icon;
  ChartData(this.category, this.price, this.percent, this.color, this.icon);
}

class UserChartData {
  String? category;
  int? price;
  double? percent;
  Color? color;
  String? imgURL;
  UserChartData({required this.category, required this.price, required this.percent, required this.color, required this.imgURL});
}
