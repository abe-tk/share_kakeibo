import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class AppDetailList extends StatelessWidget {
  final String price;
  final String largeCategory;
  final String smallCategory;
  final String paymentUser;
  final String memo;
  final DateTime date;
  final Function function;

  const AppDetailList({
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
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: listBorderSideColor,
          ),
        ),
      ),
      child: ListTile(
        leading: viewIcon(smallCategory),
        title: Text(smallCategory),
        subtitle: Column(
          children: [
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
    );
  }
}
