import 'package:flutter/material.dart';
import 'package:share_kakeibo/impoter.dart';

class TotalAssets extends StatelessWidget {
  final int price;
  final bool obscure;
  final Function function;

  const TotalAssets({
    required this.price,
    required this.obscure,
    required this.function,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: boxShadowColor,
                spreadRadius: 1.0,
              ),
            ],
            color: boxColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: Text('総資産額', style: TextStyle(color: detailIconColor),),
            title: Text(
              obscure ? '*** 円' : '${formatter.format(price)} 円',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                function();
              },
            ),
          ),
        ),
      ),
    );
  }
}
