import 'package:flutter/material.dart';
import 'package:share_kakeibo/importer.dart';

class CustomListTile extends StatelessWidget {
  final String? title;
  final Icon? leading;
  final String? subTitle;
  final bool isTrailing;
  final VoidCallback? onTaped;

  const CustomListTile({
    Key? key,
    this.title,
    this.leading,
    this.subTitle,
    this.isTrailing = true,
    this.onTaped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isTrailing
            ? Container(
                height: 54,
                width: double.infinity,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.chevron_right),
              )
            : const SizedBox.shrink(),
        InkWell(
          onTap: onTaped,
          child: Container(
            height: 54,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                leading ?? const SizedBox.shrink(),
                const SizedBox(width: 16),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: context.titleMediumBold,
                    ),
                    subTitle != null
                        ? Text(
                            '$subTitle',
                            style: context.bodySmall,
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
