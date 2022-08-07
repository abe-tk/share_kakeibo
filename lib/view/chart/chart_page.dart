/// view
import 'package:share_kakeibo/view/chart/spending_chart.dart';
import 'package:share_kakeibo/view/chart/income_chart.dart';

/// view_model
import 'package:share_kakeibo/view_model/chart/chart_view_model.dart';

/// packages
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
  void initState() {
    super.initState();
    ref.read(chartViewModelProvider).calc();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = useState(<bool>[true, false]);
    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const ChartPageNowMonth(),
            centerTitle: true,
            backgroundColor: const Color(0xFFFCF6EC),
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50.0),
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: const TabBar(tabs: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '収入',
                                style: TextStyle(color: Color(0xFF725B51),fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                '支出',
                                style: TextStyle(color: Color(0xFF725B51),fontSize: 16),
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
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: ToggleButtons(
                        fillColor: const Color(0xFF725B51),
                        selectedColor: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        borderWidth: 2,
                        borderColor: const Color(0xFF725B51),
                        selectedBorderColor: const Color(0xFF725B51),
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
                              await ref
                                  .read(chartViewModelProvider)
                                  .changeChart(true);
                              ref.read(chartViewModelProvider).calc();
                              break;
                            case 1:
                              await ref
                                  .read(chartViewModelProvider)
                                  .changeChart(false);
                              ref.read(chartViewModelProvider).calc();
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
          body: TabBarView(
            children: [
              IncomeChart(),
              SpendingChart(),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartPageNowMonth extends HookConsumerWidget {
  const ChartPageNowMonth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chartViewModel = ref.watch(chartViewModelProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.grey,
          ),
          onPressed: () async {
            await chartViewModel.oneMonthAgo();
            chartViewModel.calc();
          },
        ),
        TextButton(
          child: Text(
            '- ${DateFormat.yMMM('ja').format(ref.watch(chartViewModelProvider).nowMonth)} -',
            style: const TextStyle(
              fontSize: 24,
              color: Color(0xFF725B51),
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () async {
            await chartViewModel.selectMonth(context);
            chartViewModel.calc();
          },
        ),
        IconButton(
          icon: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
          onPressed: () async {
            await chartViewModel.oneMonthLater();
            chartViewModel.calc();
          },
        ),
      ],
    );
  }
}

