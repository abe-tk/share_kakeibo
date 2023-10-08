import 'package:flutter/material.dart';

import '../importer.dart';

extension TextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextStyle get bodyMediumBold => theme.textTheme.bodyMedium!.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );

  TextStyle get bodyMediumGrey => theme.textTheme.bodyMedium!.copyWith(
        color: CustomColor.detailTextColor,
      );

  TextStyle get bodyMediumRed => theme.textTheme.bodyMedium!.copyWith(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      );

  TextStyle get bodyLargeBold => theme.textTheme.bodyLarge!.copyWith(
        fontWeight: FontWeight.bold,
      );

  TextStyle get titleMediumBold => theme.textTheme.titleMedium!.copyWith(
        fontWeight: FontWeight.bold,
      );

  TextStyle get bodySmall => theme.textTheme.bodySmall!;
}
