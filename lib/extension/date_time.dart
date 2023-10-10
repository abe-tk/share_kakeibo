import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String get mmmEd {
    return DateFormat.MMMEd('ja').format(this);
  }
}
