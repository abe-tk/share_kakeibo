import 'package:flutter/material.dart';

extension TextThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextStyle get bodyMediumBold => theme.textTheme.bodyMedium!.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      );

  TextStyle get bodyMediumGrey => theme.textTheme.bodyMedium!.copyWith(
        color: Colors.grey,
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
