// firebase
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share_kakeibo/firebase/auth_fire.dart';
import 'package:share_kakeibo/firebase/price_fire.dart';
import 'package:share_kakeibo/firebase/room_fire.dart';
// model
import 'package:share_kakeibo/model/pie_data/pie_data.dart';
import 'package:share_kakeibo/state/current_month/bar_chart_year_state.dart';
// state
import 'package:share_kakeibo/state/current_month/home_current_month_state.dart';
// utility
import 'package:share_kakeibo/utility/pie_chart_utility.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

final yearChartProvider = StateNotifierProvider<YearChartNotifier, List<double>>((ref) {
  return YearChartNotifier();
});

class YearChartNotifier extends StateNotifier<List<double>> {
  YearChartNotifier() : super([0,0,0,0,0,0,0,0,0,0,0,0]);

  late String roomCode;

  Future<void> setBarChartData() async {
    roomCode = await setRoomCodeFire(uid);
    List<double> prices = [0,0,0,0,0,0,0,0,0,0,0,0];
    for (int i = 0; i < state.length; i++) {
      prices[i] = await setYearChartPrice(roomCode, i + 1);
      // state[i] = await setYearChartPrice(roomCode, i + 1);
      // state.add(price);
    }
    state = prices;
  }

  Future<double> setYearChartPrice(String code, int month) async {
    double calcResult = 0;
    List<double> prices = [];
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(code)
        .collection('events')
        .where('registerDate', isEqualTo: DateTime(CurrentYearNotifier().state.year, month))
        .where('largeCategory', isEqualTo: '支出')
        .get();
    for (final document in snapshot.docs) {
      final event = document.data();
      final price = event['price'];
      prices.add(double.parse(price));
      double calcResults = prices.reduce((a, b) => a + b);
      calcResult = calcResults;
    }
    return calcResult;
  }

}
