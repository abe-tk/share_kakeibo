import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class HomePage extends StatefulHookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // エラーの出ていた処理
      ref.read(totalAssetsStateProvider.notifier).calc();
      ref.read(bpPieChartStateProvider.notifier).calc(DateTime(DateTime.now().year, DateTime.now().month));
    });
  }

  @override
  Widget build(BuildContext context) {
    final roomNameState = ref.watch(roomNameProvider);
    final total = ref.watch(totalAssetsStateProvider);
    final _isObscure = useState(true);
    final month = useState(DateTime(DateTime.now().year, DateTime.now().month));
    final bpPieChartState = ref.watch(bpPieChartStateProvider);
    final bpPieChartNotifier = ref.watch(bpPieChartStateProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        actions: [
          AppIconButton(
            icon: Icons.settings,
            color: Colors.black,
            function: () => Navigator.pushNamed(context, '/settingPage'),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBarBackGroundColor,
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: homeBoxColor,
                    border: Border(
                      bottom: BorderSide(
                        color: boxBorderSideColor,
                        width: 0.1,
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.meeting_room_rounded, color: roomNameIconColor,),
                    title: Text(roomNameState, style: const TextStyle(fontWeight: FontWeight.bold),),
                  ),
                ),
                Column(
                  children: [
                    // 総資産額
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 60, right: 16, bottom: 16),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: boxShadowColor,
                              spreadRadius: 1.0,
                            ),
                          ],
                          color: boxColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Text('総資産額', style: TextStyle(color: detailIconColor),),
                          title: Text(
                            _isObscure.value ? '*** 円' : '${formatter.format(total)} 円',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              _isObscure.value ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              _isObscure.value = !_isObscure.value;
                            },
                          ),
                        ),
                      ),
                    ),
                    // 当月の収支グラフ
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Container(
                        height: 430,
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: boxShadowColor,
                              spreadRadius: 1.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // 対象月の表示
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppIconButton(
                                  icon: Icons.chevron_left,
                                  color: detailIconColor,
                                  function: () {
                                    month.value = DateTime(month.value.year, month.value.month - 1);
                                    bpPieChartNotifier.bpPieChartCalc(month.value);
                                  },
                                ),
                                AppTextButton(
                                  text: '${DateFormat.yMMM('ja').format(month.value)}の家計簿',
                                  size: 16,
                                  color: normalTextColor,
                                  function: () async {
                                    month.value = await selectMonth(context, month.value);
                                    bpPieChartNotifier.bpPieChartCalc(month.value);
                                  },
                                ),
                                AppIconButton(
                                  icon: Icons.chevron_right,
                                  color: detailIconColor,
                                  function: () {
                                    month.value = DateTime(month.value.year, month.value.month + 1);
                                    bpPieChartNotifier.bpPieChartCalc(month.value);
                                  },
                                ),
                              ],
                            ),
                            // 円グラフの表示
                            Container(
                              margin: const EdgeInsets.only(top: 24, bottom: 24),
                              height: 160,
                              width: 160,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '収支',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: pieChartCenterTextColor,
                                        ),
                                      ),
                                      Text(
                                        '${formatter.format(bpPieChartNotifier.totalPrice)}円',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: pieChartCenterTextColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      children: <Widget>[
                                        Expanded(
                                          child: PieChart(
                                            PieChartData(
                                              borderData: FlBorderData(show: false),
                                              sectionsSpace: 1,
                                              centerSpaceRadius: 50,
                                              sections: bpPieChartState,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // 支出・収入・合計の表示
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, top: 24, right: 24, bottom: 8),
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: Row(
                                            children: [
                                              Text(
                                                '支出',
                                                style: TextStyle(color: detailTextColor),
                                              ),
                                              Text(
                                                ' / ${double.parse((bpPieChartNotifier.spendingPercent).toString()).toStringAsFixed(1)}%',
                                                style: TextStyle(
                                                  color: detailTextColor),
                                              )
                                            ],
                                          ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width:
                                        MediaQuery.of(context).size.width * 0.9,
                                        child: Text(
                                          '${formatter.format(bpPieChartNotifier.spendingPrice)} 円',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: spendingTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Stack(
                                    children: [
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: Row(
                                            children: [
                                              Text(
                                                '収入',
                                                style: TextStyle(
                                                  color: detailTextColor,),
                                              ),
                                              Text(
                                                ' / ${double.parse((bpPieChartNotifier.incomePercent).toString()).toStringAsFixed(1)}%',
                                                style: TextStyle(
                                                  color: detailTextColor,),
                                              )
                                            ],
                                          )),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width:
                                        MediaQuery.of(context).size.width * 0.9,
                                        child: Text(
                                          '${formatter.format(bpPieChartNotifier.incomePrice)} 円',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: incomeTextColor,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Stack(
                                    children: [
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        child: Text(
                                          '合計 ${formatter.format(bpPieChartNotifier.totalPrice)} 円',
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // FABに被らないようにしている
                    const SizedBox(height: 50),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
