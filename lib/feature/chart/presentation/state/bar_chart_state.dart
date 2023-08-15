import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

final barChartStateProvider = StateNotifierProvider<BarChartStateNotifier, List<double>>((ref) {
  return BarChartStateNotifier();
});

class BarChartStateNotifier extends StateNotifier<List<double>> {
  BarChartStateNotifier() : super([0,0,0,0,0,0,0,0,0,0,0,0]);

  void setBarChartData(DateTime date, List<QueryDocumentSnapshot<Map<String, dynamic>>> event) {
    List<double> prices = [0,0,0,0,0,0,0,0,0,0,0,0];
    for (int i = 0; i < state.length; i++) {
      prices[i] = setYearChartPrice(event, date, i + 1);
    }
    state = prices;
  }

}
