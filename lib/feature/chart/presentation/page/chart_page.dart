import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/feature/chart/application/pie_chart_service.dart';
import 'package:share_kakeibo/feature/chart/presentation/state/pie_chart_state.dart';
import 'package:share_kakeibo/importer.dart';

class ChartPage extends HookConsumerWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 円グラフのデータ
    final pieData = ref.watch(pieChartProvider);

    // 月の選択
    final month = useState(DateTime(DateTime.now().year, DateTime.now().month));

    // 表示切り替え（カテゴリかどうか）
    final isCategory = useState(true);

    // 大カテゴリ
    final largeCategory = useState('収入');

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            TargetDate(
              month: month.value,
              onTapedDate: () async {
                month.value = await selectMonth(context, month.value);
                ref.read(pieChartProvider.notifier).reCalc(
                      isCategory.value,
                      month.value,
                      largeCategory.value,
                    );
              },
              onTapedLeft: () {
                month.value = DateTime(month.value.year, month.value.month - 1);
                ref.read(pieChartProvider.notifier).reCalc(
                      isCategory.value,
                      month.value,
                      largeCategory.value,
                    );
              },
              onTapedRight: () {
                month.value = DateTime(month.value.year, month.value.month + 1);
                ref.read(pieChartProvider.notifier).reCalc(
                      isCategory.value,
                      month.value,
                      largeCategory.value,
                    );
              },
            ),
            // 円グラフの表示
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: CustomPieChart(
                category: largeCategory.value,
                pieChartSectionData: PieChartService().getCategory(
                  PieChartService().setPieData(
                    pieData.values.first,
                    pieData.keys.first,
                  ),
                ),
                price: pieData.keys.first,
                onTaped: () {
                  switch (largeCategory.value) {
                    case '収入':
                      largeCategory.value = '支出';
                      ref.read(pieChartProvider.notifier).reCalc(
                            isCategory.value,
                            month.value,
                            largeCategory.value,
                          );
                      break;
                    case '支出':
                      largeCategory.value = '収入';
                      ref.read(pieChartProvider.notifier).reCalc(
                            isCategory.value,
                            month.value,
                            largeCategory.value,
                          );
                      break;
                  }
                },
              ),
            ),
            // 表示切り替え
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: isCategory.value
                      ? null
                      : () {
                          isCategory.value = !isCategory.value;
                          ref.read(pieChartProvider.notifier).reCalc(
                                isCategory.value,
                                month.value,
                                largeCategory.value,
                              );
                        },
                  icon: const Icon(Icons.category),
                ),
                IconButton(
                  onPressed: isCategory.value
                      ? () {
                          isCategory.value = !isCategory.value;
                          ref.read(pieChartProvider.notifier).reCalc(
                                isCategory.value,
                                month.value,
                                largeCategory.value,
                              );
                        }
                      : null,
                  icon: const Icon(Icons.person),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // 円グラフ内の各値をリスト表示
            Expanded(
              child: ListView.builder(
                itemCount: pieData.values.first.length + 1,
                itemBuilder: (context, index) {
                  if (index == pieData.values.first.length) {
                    // リストの最後に合計値を表示
                    return Container(
                      alignment: Alignment.centerRight,
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(right: 16, bottom: 30),
                      child: Text(
                        '合計 ${numberFormatter.format(pieData.keys.first)} 円',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: CustomColor.detailTextColor,
                        ),
                      ),
                    );
                  }
                  // 各値
                  return Visibility(
                    visible: pieData.values.first[index]['price'] != 0
                        ? true
                        : false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CustomShadowContainer(
                        height: 48,
                        // onTap: ,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const SizedBox(width: 16),
                                isCategory.value == true
                                    // カテゴリのアイコン
                                    ? Icon(
                                        pieData.values.first[index]['icon'],
                                        color: pieData.values.first[index]
                                            ['color'],
                                      )
                                    // ユーザのプロフィール画像
                                    : CircleAvatar(
                                        radius: 12,
                                        backgroundImage: NetworkImage(
                                          pieData.values.first[index]['imgURL'],
                                        ),
                                      ),
                                const SizedBox(width: 10),
                                // カテゴリ名
                                Text(
                                  pieData.values.first[index]['category'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // パーセント
                                Text(
                                  ' ${double.parse((pieData.values.first[index]['percent']).toString()).toStringAsFixed(1)}%',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                            // 金額
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: Text(
                                '${numberFormatter.format(pieData.values.first[index]['price'])} 円',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
