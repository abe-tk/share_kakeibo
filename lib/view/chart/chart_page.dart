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
  void reCalc(DateTime date) {
    ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(date, ref.read(eventProvider));
    ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(date, ref.read(eventProvider));
    ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(date, ref.read(eventProvider), ref.read(roomMemberProvider));
    ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(date, ref.read(eventProvider), ref.read(roomMemberProvider));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider));
      ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider));
      ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider), ref.read(roomMemberProvider));
      ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider), ref.read(roomMemberProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    final month = useState(DateTime(DateTime.now().year, DateTime.now().month));
    final isSelected = useState(<bool>[true, false]);
    final isDisplay = useState(true);
    final incomeCategoryPieChartState = ref.watch(incomeCategoryPieChartStateProvider);
    final incomeCategoryPieChartNotifier = ref.watch(incomeCategoryPieChartStateProvider.notifier);
    final spendingCategoryPieChartState = ref.watch(spendingCategoryPieChartStateProvider);
    final spendingCategoryPieChartNotifier = ref.watch(spendingCategoryPieChartStateProvider.notifier);
    final incomeUserPieChartState = ref.watch(incomeUserPieChartStateProvider);
    final incomeUserPieChartNotifier = ref.watch(incomeUserPieChartStateProvider.notifier);
    final spendingUserPieChartState = ref.watch(spendingUserPieChartStateProvider);
    final spendingUserPieChartNotifier = ref.watch(spendingUserPieChartStateProvider.notifier);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: appBarBackGroundColor,
          elevation: 0,
          title: SelectMonth(
            month: month.value,
            left: () {
              month.value = DateTime(month.value.year, month.value.month - 1);
              reCalc(month.value);
            },
            center: () async {
              month.value = await selectMonth(context, month.value);
              reCalc(month.value);
            },
            right: () {
              month.value = DateTime(month.value.year, month.value.month + 1);
              reCalc(month.value);
            },
          ),
          actions: [
            AppIconButton(
              icon: Icons.analytics_outlined,
              color: normalTextColor,
              function: () {
                Navigator.pushNamed(context, '/yearChartPage');
              },
            ),
          ],
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
                AppToggleButton(
                  isSelected: isSelected.value,
                  isDisplay: isDisplay.value,
                  function: (index) async {
                    // setStatedではなくもっとシンプルに書けるのでは
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
              ],
            ),
          ),
        ),
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: TabBarView(
            children: [
              isDisplay.value == true
                  ? ChartPagePie(
                      largeCategory: '収入',
                      category: true,
                      pieChartSectionData: incomeCategoryPieChartState,
                      totalPrice: incomeCategoryPieChartNotifier.totalPrice,
                      length: incomeCategoryPieChartNotifier.chartSourceData.length,
                      chartSourceData: incomeCategoryPieChartNotifier.chartSourceData,
                    )
                  : ChartPagePie(
                      largeCategory: '収入',
                      category: false,
                      pieChartSectionData: incomeUserPieChartState,
                      totalPrice: incomeUserPieChartNotifier.totalPrice,
                      length: incomeUserPieChartNotifier.chartSourceData.length,
                      chartSourceData: incomeUserPieChartNotifier.chartSourceData,
                    ),
              isDisplay.value == true
                  ? ChartPagePie(
                      largeCategory: '支出',
                      category: true,
                      pieChartSectionData: spendingCategoryPieChartState,
                      totalPrice: spendingCategoryPieChartNotifier.totalPrice,
                      length: spendingCategoryPieChartNotifier.chartSourceData.length,
                      chartSourceData: spendingCategoryPieChartNotifier.chartSourceData,
                    )
                  : ChartPagePie(
                      largeCategory: '支出',
                      category: false,
                      pieChartSectionData: spendingUserPieChartState,
                      totalPrice: spendingUserPieChartNotifier.totalPrice,
                      length: spendingUserPieChartNotifier.chartSourceData.length,
                      chartSourceData: spendingUserPieChartNotifier.chartSourceData,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
