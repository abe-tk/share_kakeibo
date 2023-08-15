import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final indicatorProvider = ChangeNotifierProvider((ref) => Indicator());

class Indicator extends ChangeNotifier {

  void showProgressDialog(context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      transitionDuration: Duration.zero,
      barrierColor: Colors.black.withOpacity(0.5),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    notifyListeners();
  }

}
