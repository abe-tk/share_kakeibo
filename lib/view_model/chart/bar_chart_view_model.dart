// state
import 'package:share_kakeibo/state/event/event_state.dart';
// utility
import 'package:share_kakeibo/utility/price_utility.dart';
// model
import 'package:share_kakeibo/state/current_month/bar_chart_year_state.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

final yearChartViewModelProvider = StateNotifierProvider<YearChartViewModelNotifier, List<double>>((ref) {
  return YearChartViewModelNotifier();
});

class YearChartViewModelNotifier extends StateNotifier<List<double>> {
  YearChartViewModelNotifier() : super([0,0,0,0,0,0,0,0,0,0,0,0]);

  void setBarChartData() {
    List<double> prices = [0,0,0,0,0,0,0,0,0,0,0,0];
    for (int i = 0; i < state.length; i++) {
      prices[i] = setYearChartPrice(EventNotifier().state, CurrentYearNotifier().state, i + 1);
    }
    state = prices;
  }

}
