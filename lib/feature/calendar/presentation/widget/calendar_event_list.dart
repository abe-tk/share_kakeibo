import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class CalendarEventList extends StatelessWidget {
  final String price;
  final String largeCategory;
  final String smallCategory;
  final String paymentUser;
  final String memo;
  final Function function;

  const CalendarEventList({
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
        child: Container(
          decoration: BoxDecoration(
            color: CustomColor.bdColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0,
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                height: 80,
                decoration: BoxDecoration(
                  color: CustomColor.bdColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    // カテゴリのアイコン
                    viewIcon(smallCategory),
                    const SizedBox(width: 16),
                    SizedBox(
                      height: 80,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // カテゴリ名
                          Text(
                            smallCategory,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // 支払い元名
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                size: 16,
                                color: CustomColor.detailIconColor,
                              ),
                              Text(
                                '：$paymentUser',
                                style: const TextStyle(
                                    color: CustomColor.detailTextColor),
                              ),
                            ],
                          ),
                          // イベントのメモ
                          Row(
                            children: [
                              const Icon(
                                Icons.edit,
                                size: 16,
                                color: CustomColor.detailIconColor,
                              ),
                              Text(
                                '：$memo',
                                style: const TextStyle(
                                    color: CustomColor.detailTextColor),
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
                alignment: Alignment.centerRight,
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  // イベントの金額
                  child: Text(
                    (largeCategory == '収入')
                        ? '${formatter.format(int.parse(price))} 円'
                        : '- ${formatter.format(int.parse(price))} 円',
                    style: TextStyle(
                      color: (largeCategory == '収入')
                          ? CustomColor.incomeTextColor
                          : CustomColor.spendingTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        function();
      },
    );
  }
}
