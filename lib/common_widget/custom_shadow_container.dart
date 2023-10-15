import 'package:flutter/material.dart';

class CustomShadowContainer extends StatelessWidget {
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  const CustomShadowContainer({
    this.height,
    this.width,
    this.onTap,
    this.onLongPress,
    required this.child,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
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
          onLongPress: onLongPress,
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
