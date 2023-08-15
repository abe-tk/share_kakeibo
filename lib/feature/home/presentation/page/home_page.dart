import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateHomeState(ref);
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
      appBar: CustomAppBar(
        icon: Icons.settings,
        iconColor: CustomColor.defaultIconColor,
        onTaped: () => Navigator.pushNamed(context, '/settingPage'),
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
              child: Stack(
            children: [
              Column(
                children: [
                  // 総資産額
                  TotalAssets(
                    price: total,
                    obscure: _isObscure.value,
                    function: () => _isObscure.value = !_isObscure.value,
                  ),
                  // 当月の収支表
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 50,
                      top: 24,
                    ), //bottom：50 FABに被らないようにしている
                    child: Column(
                      children: [
                        // 対象月の選択
                        TargetDate(
                          month: month.value,
                          onTapedDate: () async {
                            month.value =
                                await selectMonth(context, month.value);
                            bpPieChartNotifier.bpPieChartCalc(
                                month.value, ref.read(eventProvider));
                          },
                          onTapedLeft: () {
                            month.value = DateTime(
                                month.value.year, month.value.month - 1);
                            bpPieChartNotifier.bpPieChartCalc(
                                month.value, ref.read(eventProvider));
                          },
                          onTapedRight: () {
                            month.value = DateTime(
                                month.value.year, month.value.month + 1);
                            bpPieChartNotifier.bpPieChartCalc(
                                month.value, ref.read(eventProvider));
                          },
                        ),
                        // 円グラフ
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 24, bottom: 24),
                          height: 200,
                          width: 200,
                          child: AppPieChart(
                            category: '収支',
                            pieChartSectionData: bpPieChartState,
                            price: bpPieChartNotifier.totalPrice,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
