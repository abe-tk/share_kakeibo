import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class ChartPage extends StatefulHookConsumerWidget {
  const ChartPage({Key? key}) : super(key: key);

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends ConsumerState<ChartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updatePieChartState(
          ref, DateTime(DateTime.now().year, DateTime.now().month));
    });
  }

  @override
  Widget build(BuildContext context) {
    final month = useState(DateTime(DateTime.now().year, DateTime.now().month));
    final isSelected = useState(<bool>[true, false]);
    final isDisplay = useState(true);
    final incomeCategoryPieChartState =
        ref.watch(incomeCategoryPieChartStateProvider);
    final incomeCategoryPieChartNotifier =
        ref.watch(incomeCategoryPieChartStateProvider.notifier);
    final spendingCategoryPieChartState =
        ref.watch(spendingCategoryPieChartStateProvider);
    final spendingCategoryPieChartNotifier =
        ref.watch(spendingCategoryPieChartStateProvider.notifier);
    final incomeUserPieChartState = ref.watch(incomeUserPieChartStateProvider);
    final incomeUserPieChartNotifier =
        ref.watch(incomeUserPieChartStateProvider.notifier);
    final spendingUserPieChartState =
        ref.watch(spendingUserPieChartStateProvider);
    final spendingUserPieChartNotifier =
        ref.watch(spendingUserPieChartStateProvider.notifier);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: TargetDate(
            month: month.value,
            onTapedDate: () async {
              month.value = await selectMonth(context, month.value);
              updatePieChartState(ref, month.value);
            },
            onTapedLeft: () {
              month.value = DateTime(month.value.year, month.value.month - 1);
              updatePieChartState(ref, month.value);
            },
            onTapedRight: () {
              month.value = DateTime(month.value.year, month.value.month + 1);
              updatePieChartState(ref, month.value);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.analytics_outlined,
                color: CustomColor.defaultIconColor,
              ),
              onPressed: () => Navigator.pushNamed(context, '/yearChartPage'),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const AppTabBar(
                  firstTab: '収入',
                  secondTab: '支出',
                ),
                AppToggleButton(
                  isSelected: isSelected.value,
                  isDisplay: isDisplay.value,
                  function: (index) async {
                    switch (index) {
                      case 0:
                        isDisplay.value = true;
                        isSelected.value = [true, false];
                        break;
                      case 1:
                        isDisplay.value = false;
                        isSelected.value = [false, true];
                        break;
                    }
                  },
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
                  ? ChartPageBody(
                      largeCategory: '収入',
                      category: true,
                      pieChartSectionData: incomeCategoryPieChartState,
                      totalPrice: incomeCategoryPieChartNotifier.totalPrice,
                      length:
                          incomeCategoryPieChartNotifier.chartSourceData.length,
                      chartSourceData:
                          incomeCategoryPieChartNotifier.chartSourceData,
                    )
                  : ChartPageBody(
                      largeCategory: '収入',
                      category: false,
                      pieChartSectionData: incomeUserPieChartState,
                      totalPrice: incomeUserPieChartNotifier.totalPrice,
                      length: incomeUserPieChartNotifier.chartSourceData.length,
                      chartSourceData:
                          incomeUserPieChartNotifier.chartSourceData,
                    ),
              isDisplay.value == true
                  ? ChartPageBody(
                      largeCategory: '支出',
                      category: true,
                      pieChartSectionData: spendingCategoryPieChartState,
                      totalPrice: spendingCategoryPieChartNotifier.totalPrice,
                      length: spendingCategoryPieChartNotifier
                          .chartSourceData.length,
                      chartSourceData:
                          spendingCategoryPieChartNotifier.chartSourceData,
                    )
                  : ChartPageBody(
                      largeCategory: '支出',
                      category: false,
                      pieChartSectionData: spendingUserPieChartState,
                      totalPrice: spendingUserPieChartNotifier.totalPrice,
                      length:
                          spendingUserPieChartNotifier.chartSourceData.length,
                      chartSourceData:
                          spendingUserPieChartNotifier.chartSourceData,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
