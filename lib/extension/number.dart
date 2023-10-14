import 'package:intl/intl.dart';

extension NumberExtension on int {
  String get separator => NumberFormat("#,###").format(this);
}
