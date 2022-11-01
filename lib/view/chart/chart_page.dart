// components
import 'package:share_kakeibo/components/drawer_menu.dart';
// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/pie_chart/income_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/current_month/chart_current_month_state.dart';
import 'package:share_kakeibo/state/pie_chart/income_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_user_pie_chart_state.dart';
// view
import 'package:share_kakeibo/view/chart/widget/income_category_pie_chart.dart';
import 'package:share_kakeibo/view/chart/widget/income_user_pie_chart.dart';
import 'package:share_kakeibo/view/chart/widget/spending_category_pie_chart.dart';
import 'package:share_kakeibo/view/chart/widget/spending_user_pie_chart.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class ChartPage extends StatefulHookConsumerWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends ConsumerState<ChartPage> {

  @override
  Widget build(BuildContext context) {
    final isSelected = useState(<bool>[true, false]);
    final isDisplay = useState(true);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const ChartPageNowMonth(),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/yearChartPage');
              },
              icon: const Icon(Icons.analytics_outlined),
            ),
          ],
          centerTitle: true,
          backgroundColor: appBarBackGroundColor,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: TabBar(
                          indicatorColor: tabBarIndicatorColor,
                            tabs: const [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '収入',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              '支出',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width * 0.5,
                  alignment: Alignment.bottomRight,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: ToggleButtons(
                      fillColor: toggleFillColor,
                      borderWidth: 2,
                      borderColor: toggleBorder,
                      selectedColor: toggleSelectedColor,
                      selectedBorderColor: toggleSelectedBorder,
                      borderRadius: BorderRadius.circular(10),
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('カテゴリ'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Text('支払い元'),
                        ),
                      ],
                      // （2） ON/OFFの指定
                      isSelected: isSelected.value,
                      // （3） ボタンが押されたときの処理
                      onPressed: (index) async {
                        setState(() {
                          for (int buttonIndex = 0;
                              buttonIndex < isSelected.value.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected.value[buttonIndex] = true;
                            } else {
                              isSelected.value[buttonIndex] = false;
                            }
                          }
                        });
                        switch (index) {
                          case 0:
                            isDisplay.value = true;
                            break;
                          case 1:
                            isDisplay.value = false;
                            break;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: TabBarView(
            children: [
              isDisplay.value == true
                  ? const IncomeCategoryPieChart()
                  : const IncomeUserPieChart(),
              isDisplay.value == true
                  ? const SpendingCategoryPieChart()
                  : const SpendingUserPieChart(),
              // IncomeChart(),
              // SpendingChart(),
            ],
          ),
        ),
      ),
    );
  }
}

// 対象月の変更
class ChartPageNowMonth extends StatefulHookConsumerWidget {
  const ChartPageNowMonth({Key? key}) : super(key: key);

  @override
  _ChartPageNowMonthState createState() => _ChartPageNowMonthState();
}

class _ChartPageNowMonthState extends ConsumerState<ChartPageNowMonth> {

  @override
  Widget build(BuildContext context) {
    final currentMonthNotifier = ref.watch(chartCurrentMonthProvider.notifier);
    final currentMonthState = ref.watch(chartCurrentMonthProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(
            Icons.chevron_left,
            color: detailIconColor,
          ),
          onPressed: () async {
            await currentMonthNotifier.oneMonthAgo();
            ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc();
            ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc();
            ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc();
            ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc();
          },
        ),
        TextButton(
          child: Text(
            DateFormat.yMMM('ja').format(currentMonthState),
            style: TextStyle(
              fontSize: 20,
              color: normalTextColor,
            ),
          ),
          onPressed: () async {
            await currentMonthNotifier.selectMonth(context);
            ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc();
            ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc();
            ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc();
            ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc();
          },
        ),
        IconButton(
          icon: Icon(
            Icons.chevron_right,
            color: detailIconColor,
          ),
          onPressed: () async {
            await currentMonthNotifier.oneMonthLater();
            ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc();
            ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc();
            ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc();
            ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc();
          },
        ),
      ],
    );
  }
}
