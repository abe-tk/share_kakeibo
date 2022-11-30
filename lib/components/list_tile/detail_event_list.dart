import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class DetailEventList extends StatelessWidget {
  final String price;
  final String largeCategory;
  final String smallCategory;
  final String paymentUser;
  final String memo;
  final DateTime date;
  final Function function;

  const DetailEventList({
    required this.price,
    required this.largeCategory,
    required this.smallCategory,
    required this.paymentUser,
    required this.memo,
    required this.date,
    required this.function,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: boxColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                spreadRadius: 1.0,
              ),
            ],
          ),
          child: ListTile(
            // カテゴリのアイコン
            leading: viewIcon(smallCategory),
            // カテゴリ名
            title: Text(
              smallCategory,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              children: [
                // 支払い元名
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 16,
                      color: detailIconColor,
                    ),
                    Text('：$paymentUser'),
                  ],
                ),
                // イベントのメモ
                Row(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 16,
                      color: detailIconColor,
                    ),
                    Text('：$memo'),
                  ],
                ),
                // イベントの日付
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: detailIconColor,
                    ),
                    Text('：${DateFormat.MMMEd('ja').format(date)}'),
                  ],
                ),
              ],
            ),
            // イベントの金額
            trailing: Text(
              (largeCategory == '収入')
                  ? '${formatter.format(int.parse(price))} 円'
                  : '- ${formatter.format(int.parse(price))} 円',
              style: TextStyle(
                color: (largeCategory == '収入')
                    ? incomeTextColor
                    : spendingTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              function();
            },
          ),
        ),
      ),
    );
  }
}
