import 'package:flutter/material.dart';

Icon viewIcon(String category) {
  switch (category) {
    case '給与':
      return const Icon(Icons.account_balance_wallet,
          color: Color(0xFFffd700), size: 30);
    case '賞与':
      return const Icon(Icons.payments, color: Color(0xFFff8c00), size: 30);
    case '臨時収入':
      return const Icon(Icons.currency_yen, color: Color(0xFFff6347), size: 30);
    case '食費':
      return const Icon(Icons.rice_bowl, color: Color(0xFFffe4b5), size: 30);
    case '外食費':
      return const Icon(Icons.restaurant, color: Color(0xFFfa8072), size: 30);
    case '日用雑貨費':
      return const Icon(Icons.shopping_cart,
          color: Color(0xFFdeb887), size: 30);
    case '交通・車両費':
      return const Icon(Icons.directions_car_outlined,
          color: Color(0xFFb22222), size: 30);
    case '住居費':
      return const Icon(Icons.house, color: Color(0xFFf4a460), size: 30);
    case '光熱費(電気)':
      return const Icon(Icons.bolt, color: Color(0xFFf0e68c), size: 30);
    case '光熱費(ガス)':
      return const Icon(Icons.local_fire_department,
          color: Color(0xFFdc143c), size: 30);
    case '水道費':
      return const Icon(Icons.water_drop, color: Color(0xFF00bfff), size: 30);
    case '通信費':
      return const Icon(Icons.speaker_phone,
          color: Color(0xFFff00ff), size: 30);
    case 'レジャー費':
      return const Icon(Icons.music_note, color: Color(0xFF3cb371), size: 30);
    case '教育費':
      return const Icon(Icons.school, color: Color(0xFF9370db), size: 30);
    case '医療費':
      return const Icon(Icons.local_hospital_outlined,
          color: Color(0xFFff7f50), size: 30);
    case 'ファッション費':
      return const Icon(Icons.checkroom, color: Color(0xFFffc0cb), size: 30);
    case '美容費':
      return const Icon(Icons.spa, color: Color(0xFFee82ee), size: 30);
    default: // 未分類
      return const Icon(Icons.question_mark, color: Colors.grey, size: 30);
  }
}