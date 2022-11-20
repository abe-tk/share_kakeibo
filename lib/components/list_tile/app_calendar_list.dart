import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class AppCalendarList extends StatelessWidget {
  final String price;
  final String largeCategory;
  final String smallCategory;
  final String paymentUser;
  final String memo;
  final Function function;

  const AppCalendarList({
    required this.price,
    required this.largeCategory,
    required this.smallCategory,
    required this.paymentUser,
    required this.memo,
    required this.function,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              height: 80,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  viewIcon(smallCategory),
                  // 表示するアイコン
                  const SizedBox(width: 16),
                  SizedBox(
                    height: 80,
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          smallCategory,
                          style: const TextStyle(
                              fontWeight:
                              FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: detailIconColor,
                            ),
                            Text(
                              '：$paymentUser',
                              style: TextStyle(
                                  color: detailTextColor),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: detailIconColor,
                            ),
                            Text(
                              '：$memo',
                              style: TextStyle(
                                  color: detailTextColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // margin: EdgeInsets.all(0),
              alignment: Alignment.centerRight,
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding:
                const EdgeInsets.only(right: 16.0),
                child: Text(
                  (largeCategory == '収入')
                      ? '${formatter.format(int.parse(price))} 円'
                      : '- ${formatter.format(int.parse(price))} 円',
                  style: TextStyle(
                      color: (largeCategory == '収入')
                          ? incomeTextColor
                          : spendingTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          function();
        },
      ),
    );
  }
}
