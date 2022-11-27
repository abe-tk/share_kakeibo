import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

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
          fillColor: toggleFillColor,
          borderWidth: 2,
          borderColor: toggleBorder,
          selectedColor: toggleSelectedColor,
          selectedBorderColor: toggleSelectedBorder,
          borderRadius: BorderRadius.circular(10),
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
