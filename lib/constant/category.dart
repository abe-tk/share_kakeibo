import 'package:flutter/material.dart';

class Category {
  static const List<Map<String, Object>> bp = [
    {
      'category': '収入',
      'color': Colors.greenAccent,
    },
    {
      'category': '支出',
      'color': Colors.redAccent,
    },
  ];

  static const List<Map<String, Object>> plus = [
    {
      'category': '給与',
      'icon': Icons.account_balance_wallet,
      'color': Color(0xFFffd700),
    },
    {
      'category': '賞与',
      'icon': Icons.payments,
      'color': Color(0xFFff8c00),
    },
    {
      'category': '臨時収入',
      'icon': Icons.currency_yen,
      'color': Color(0xFFff6347),
    },
    {
      'category': '未分類',
      'icon': Icons.question_mark,
      'color': Colors.grey,
    },
  ];

  static const List<Map<String, Object>> minus = [
    {
      'category': '食費',
      'icon': Icons.rice_bowl,
      'color': Color(0xFFffe4b5),
    },
    {
      'category': '外食費',
      'icon': Icons.restaurant,
      'color': Color(0xFFfa8072),
    },
    {
      'category': '日用雑貨費',
      'icon': Icons.shopping_cart,
      'color': Color(0xFFdeb887),
    },
    {
      'category': '交通・車両費',
      'icon': Icons.directions_car_outlined,
      'color': Color(0xFFb22222),
    },
    {
      'category': '住居費',
      'icon': Icons.house,
      'color': Color(0xFFf4a460),
    },
    {
      'category': '光熱費(電気)',
      'icon': Icons.bolt,
      'color': Color(0xFFf0e68c),
    },
    {
      'category': '光熱費(ガス)',
      'icon': Icons.local_fire_department,
      'color': Color(0xFFdc143c),
    },
    {
      'category': '水道費',
      'icon': Icons.water_drop,
      'color': Color(0xFF00bfff),
    },
    {
      'category': '通信費',
      'icon': Icons.speaker_phone,
      'color': Color(0xFFff00ff),
    },
    {
      'category': 'レジャー費',
      'icon': Icons.music_note,
      'color': Color(0xFF3cb371),
    },
    {
      'category': '教育費',
      'icon': Icons.school,
      'color': Color(0xFF9370db),
    },
    {
      'category': '医療費',
      'icon': Icons.local_hospital_outlined,
      'color': Color(0xFFff7f50),
    },
    {
      'category': 'ファッション費',
      'icon': Icons.checkroom,
      'color': Color(0xFFffc0cb),
    },
    {
      'category': '美容費',
      'icon': Icons.spa,
      'color': Color(0xFFee82ee),
    },
    {
      'category': '未分類',
      'icon': Icons.question_mark,
      'color': Colors.grey,
    },
  ];
}
