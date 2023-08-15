import 'package:flutter/material.dart';

class AppToggleButton extends StatelessWidget {
  final List<bool> isSelected;
  final bool isDisplay;
  final Function function;
  const AppToggleButton({
    Key? key,
    required this.isSelected,
    required this.isDisplay,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      alignment: Alignment.bottomRight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: ToggleButtons(
          children: const [
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text('カテゴリ'),
            ),
            Padding(
              padding: EdgeInsets.all(4.0),
              child: Text('支払い元'),
            ),
          ],
          // （2） ON/OFFの指定
          isSelected: isSelected,
          // （3） ボタンが押されたときの処理
          onPressed: (index) => function(index),
        ),
      ),
    );
  }
}
