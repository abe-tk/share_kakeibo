import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class HomeBpPrice extends StatelessWidget {
  final double spendingPercent;
  final int spendingPrice;
  final double incomePercent;
  final int incomePrice;
  final int totalPrice;

  const HomeBpPrice({
    Key? key,
    required this.spendingPercent,
    required this.spendingPrice,
    required this.incomePercent,
    required this.incomePrice,
    required this.totalPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 24, right: 24, bottom: 8),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: 30,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  '支出 / ${double.parse((spendingPercent).toString()).toStringAsFixed(1)}%',
                  style: const TextStyle(color: CustomColor.detailTextColor),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                height: 30,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  '${formatter.format(spendingPrice)} 円',
                  style: const TextStyle(
                    fontSize: 20,
                    color: CustomColor.spendingTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Stack(
            children: [
              Container(
                alignment: Alignment.bottomLeft,
                height: 30,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  '収入 / ${double.parse((incomePercent).toString()).toStringAsFixed(1)}%',
                  style: const TextStyle(color: CustomColor.detailTextColor),
                ),
              ),
              Container(
                alignment: Alignment.bottomRight,
                height: 30,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  '${formatter.format(incomePrice)} 円',
                  style: const TextStyle(
                    fontSize: 20,
                    color: CustomColor.incomeTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerRight,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  '合計 ${formatter.format(totalPrice)} 円',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
