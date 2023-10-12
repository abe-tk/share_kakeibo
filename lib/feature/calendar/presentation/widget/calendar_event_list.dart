import 'package:flutter/material.dart';
import 'package:share_kakeibo/importer.dart';

class CalendarEventList extends StatelessWidget {
  final String price;
  final String largeCategory;
  final String smallCategory;
  final String paymentUser;
  final String memo;
  final VoidCallback onTap;

  const CalendarEventList({
    required this.price,
    required this.largeCategory,
    required this.smallCategory,
    required this.paymentUser,
    required this.memo,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: CustomShadowContainer(
        height: 80,
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // カテゴリのアイコン
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: viewIcon(smallCategory),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // カテゴリ名
                    Text(
                      smallCategory,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // 支払い元名
                    _DetailItem(
                      icon: Icons.person,
                      text: paymentUser,
                    ),
                    // イベントのメモ
                    _DetailItem(
                      icon: Icons.edit,
                      text: memo,
                    ),
                  ],
                ),
              ],
            ),
            // 金額
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                (largeCategory == '収入')
                    ? '${int.parse(price).separator} 円'
                    : '- ${int.parse(price).separator} 円',
                style: TextStyle(
                  color: (largeCategory == '収入')
                      ? CustomColor.incomeTextColor
                      : CustomColor.spendingTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _DetailItem({
    required this.icon,
    required this.text,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF4B4B4B),
        ),
        Text(
          ' : $text',
          style: const TextStyle(color: Color(0xFF4B4B4B)),
        ),
      ],
    );
  }
}
