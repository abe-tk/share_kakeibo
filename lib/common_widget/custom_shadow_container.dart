import 'package:flutter/material.dart';
import 'package:share_kakeibo/importer.dart';

class CustomShadowContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final Widget child;

  const CustomShadowContainer({
    this.height,
    this.width,
    this.onTap,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
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
      // rippleEffectを全面に表示するためにInkWellを使用
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
