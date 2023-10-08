import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/importer.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 総資産額
    final totalAssets = ref.watch(totalAssetsStateProvider);

    // 総資産額の表示・非表示
    final _isObscure = useState(true);

    // 収支円グラフの対象月
    final month = useState(DateTime(DateTime.now().year, DateTime.now().month));

    // 収支円グラフ
    final homePieChart = ref.watch(homePieChartProvider);
    final homePieChartNotifier = ref.read(homePieChartProvider.notifier);

    // イベント
    final event = ref.watch(eventProvider).whenOrNull(
          skipLoadingOnRefresh: false,
          data: (data) => data,
        );

    // TODO(takuro): 総資産額どうにかしたい
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(totalAssetsStateProvider.notifier).calcTotalAssets(event ?? []);
    });

    return Scaffold(
      appBar: CustomAppBar(
        icon: Icons.settings,
        iconColor: CustomColor.defaultIconColor,
        onTaped: () => Navigator.pushNamed(context, '/settingPage'),
      ),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              Column(
                children: [
                  // 総資産額
                  const SizedBox(height: 16),
                  _TotalAssets(
                    price: totalAssets,
                    obscure: _isObscure.value,
                    onTap: () => _isObscure.value = !_isObscure.value,
                  ),

                  // 収支円グラフの対象月
                  const SizedBox(height: 32),
                  TargetDate(
                    month: month.value,
                    onTapedDate: () async {
                      month.value = await selectMonth(
                        context,
                        month.value,
                      );
                      homePieChartNotifier.reCalc(month.value);
                    },
                    onTapedLeft: () {
                      month.value = DateTime(
                        month.value.year,
                        month.value.month - 1,
                      );
                      homePieChartNotifier.reCalc(month.value);
                    },
                    onTapedRight: () {
                      month.value = DateTime(
                        month.value.year,
                        month.value.month + 1,
                      );
                      homePieChartNotifier.reCalc(month.value);
                    },
                  ),

                  // 円グラフ
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 24, bottom: 24),
                    height: 200,
                    width: 200,
                    child: CustomPieChart(
                      category: '合計',
                      pieChartSectionData: homePieChart.values.first,
                      price: homePieChart.keys.first,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TotalAssets extends StatelessWidget {
  final int price;
  final bool obscure;
  final VoidCallback onTap;

  const _TotalAssets({
    required this.price,
    required this.obscure,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomShadowContainer(
        height: 60,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '総資産額',
                style: TextStyle(
                  color: Color(0xFF4B4B4B),
                ),
              ),
              Text(
                obscure ? '*** 円' : '${numberFormatter.format(price)} 円',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
