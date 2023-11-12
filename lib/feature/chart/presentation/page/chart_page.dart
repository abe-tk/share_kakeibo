import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:share_kakeibo/importer.dart';

class ChartPage extends HookConsumerWidget {
  const ChartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // PieChartServiceのプロバイダ
    final pieChartService = ref.watch(pieChartServiceProvider);

    // 円グラフ
    final pieChart = ref.watch(pieChartProvider);
    final pieChartNotifier = ref.watch(pieChartProvider.notifier);

    // 月の選択
    final month = useState(DateTime(DateTime.now().year, DateTime.now().month));

    // 表示切り替え（カテゴリかどうか）
    final isCategory = useState(true);

    // 大カテゴリ
    final largeCategory = useState('収入');

    void chartReCalc() {
      pieChartNotifier.reCalc(
        isCategory: isCategory.value,
        date: month.value,
        largeCategory: largeCategory.value,
      );
    }

    // 月の選択
    Future<DateTime> _selectMonth(BuildContext context, DateTime date) async {
      var selectedMonth = await showMonthPicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(DateTime.now().year - 1),
        lastDate: DateTime(DateTime.now().year + 1),
      );
      if (selectedMonth == null) {
        return date;
      } else {
        return selectedMonth;
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // 円グラフの対象月
            TargetDate(
              month: month.value,
              onTapedDate: () async {
                month.value = await _selectMonth(
                  context,
                  month.value,
                );
                chartReCalc();
              },
              onTapedLeft: () {
                month.value = DateTime(
                  month.value.year,
                  month.value.month - 1,
                );
                chartReCalc();
              },
              onTapedRight: () {
                month.value = DateTime(
                  month.value.year,
                  month.value.month + 1,
                );
                chartReCalc();
              },
            ),

            // 円グラフの表示
            SizedBox(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: CustomPieChart(
                category: largeCategory.value,
                pieChartSectionData: pieChartService.getCategory(
                  pieChartSourceData: pieChart.pieChartSourceData,
                ),
                price: pieChart.totalPrice,
                onTaped: () {
                  switch (largeCategory.value) {
                    case '収入':
                      largeCategory.value = '支出';
                      pieChartNotifier.reCalc(
                        isCategory: isCategory.value,
                        date: month.value,
                        largeCategory: largeCategory.value,
                      );
                      break;
                    case '支出':
                      largeCategory.value = '収入';
                      pieChartNotifier.reCalc(
                        isCategory: isCategory.value,
                        date: month.value,
                        largeCategory: largeCategory.value,
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
                          pieChartNotifier.reCalc(
                            isCategory: isCategory.value,
                            date: month.value,
                            largeCategory: largeCategory.value,
                          );
                        },
                  icon: const Icon(Icons.category),
                ),
                IconButton(
                  onPressed: isCategory.value
                      ? () {
                          isCategory.value = !isCategory.value;
                          pieChartNotifier.reCalc(
                            isCategory: isCategory.value,
                            date: month.value,
                            largeCategory: largeCategory.value,
                          );
                        }
                      : null,
                  icon: const Icon(Icons.person),
                ),
              ],
            ),
            const Gap(6),

            // 円グラフ内の各値をリスト表示
            Expanded(
              child: ListView.builder(
                itemCount: pieChart.pieChartSourceData.length + 1,
                itemBuilder: (context, index) {
                  if (index == pieChart.pieChartSourceData.length) {
                    // リストの最後に合計値を表示
                    return Column(
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.only(right: 16, bottom: 30),
                          child: Text(
                            '合計 ${pieChart.totalPrice.separator} 円',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const Gap(80),
                      ],
                    );
                  }

                  // 各値
                  return Visibility(
                    visible: pieChart.pieChartSourceData[index].price != 0
                        ? true
                        : false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CustomShadowContainer(
                        height: 48,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Gap(16),
                                isCategory.value == true
                                    // カテゴリのアイコン
                                    ? Icon(
                                        pieChart.pieChartSourceData[index].icon,
                                        color: pieChart
                                            .pieChartSourceData[index].color,
                                      )
                                    // ユーザのプロフィール画像
                                    : CircleAvatar(
                                        radius: 12,
                                        backgroundImage: NetworkImage(
                                          pieChart.pieChartSourceData[index]
                                              .imgURL ?? imgURL,
                                        ),
                                      ),
                                const Gap(10),

                                // カテゴリ名
                                Text(
                                  pieChart.pieChartSourceData[index].category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // パーセント
                                Text(
                                  ' ${double.parse((pieChart.pieChartSourceData[index].percent).toString()).toStringAsFixed(1)}%',
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
                                '${pieChart.pieChartSourceData[index].price.separator} 円',
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
