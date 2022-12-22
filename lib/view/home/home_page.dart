import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomNameState = ref.watch(roomNameProvider);
    final total = ref.watch(totalAssetsStateProvider);
    final _isObscure = useState(true);
    final month = useState(DateTime(DateTime.now().year, DateTime.now().month));
    final bpPieChartState = ref.watch(bpPieChartStateProvider);
    final bpPieChartNotifier = ref.watch(bpPieChartStateProvider.notifier);
    return Scaffold(
      appBar: ActionAppBar(
        title: '',
        icon: Icons.settings,
        iconColor: CustomColor.defaultIconColor,
        function: () => Navigator.pushNamed(context, '/settingPage'),
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Stack(
              children: [
                // appBar下のルーム名の背景をグレーにしている
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: CustomColor.appBarBackgroundColor,
                    border: Border(
                      bottom: BorderSide(
                        color: CustomColor.bdBorderSideColor,
                        width: 0.1,
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    // ルーム名
                    ListTile(
                      leading: const Icon(Icons.meeting_room_rounded, color: CustomColor.defaultIconColor,),
                      title: Text(roomNameState, style: const TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    // 総資産額
                    TotalAssets(
                      price: total,
                      obscure: _isObscure.value,
                      function: () => _isObscure.value = !_isObscure.value,
                    ),
                    // 当月の収支表
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50), //bottom：50 FABに被らないようにしている
                      child: Material(
                        elevation: 6,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          height: 430,
                          decoration: BoxDecoration(
                            color: CustomColor.bdColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: CustomColor.bdShadowColor,
                                spreadRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              // 対象月の選択
                              SelectMonth(
                                month: month.value,
                                left: () {
                                  month.value = DateTime(month.value.year, month.value.month - 1);
                                  bpPieChartNotifier.bpPieChartCalc(month.value, ref.read(eventProvider));
                                },
                                center: () async {
                                  month.value = await selectMonth(context, month.value);
                                  bpPieChartNotifier.bpPieChartCalc(month.value, ref.read(eventProvider));
                                },
                                right: () {
                                  month.value = DateTime(month.value.year, month.value.month + 1);
                                  bpPieChartNotifier.bpPieChartCalc(month.value, ref.read(eventProvider));
                                },
                              ),
                              // 円グラフ
                              Container(
                                margin: const EdgeInsets.only(top: 24, bottom: 24),
                                height: 160,
                                width: 160,
                                child: AppPieChart(
                                  category: '収支',
                                  pieChartSectionData: bpPieChartState,
                                  price: bpPieChartNotifier.totalPrice,
                                ),
                              ),
                              // 支出・収入・合計の金額
                              HomeBpPrice(
                                spendingPercent: bpPieChartNotifier.spendingPercent,
                                spendingPrice: bpPieChartNotifier.spendingPrice,
                                incomePercent: bpPieChartNotifier.incomePercent,
                                incomePrice: bpPieChartNotifier.incomePrice,
                                totalPrice: bpPieChartNotifier.totalPrice,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
