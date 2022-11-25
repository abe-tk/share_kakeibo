import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class AddEventPage extends HookConsumerWidget {
  const AddEventPage({Key? key, required this.largeCategory}) : super(key: key);
  final String largeCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = useState('');
    final priceController = useState(TextEditingController());
    final date = useState(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    final smallCategory = useState('未分類');
    final paymentUser = useState(ref.watch(userProvider)['userName']);
    final memo = useState('');
    final memoController = useState(TextEditingController());

    Future<void> addEvent() async {
      try {
        addEventValidation(price.value);
        await addEventFire(
          ref.watch(roomCodeProvider),
          date.value,
          price.value,
          largeCategory,
          smallCategory.value,
          memo.value,
          DateTime(date.value.year, date.value.month),
          paymentUser.value,
        );
        await EventNotifier().setEvent();
        // ホーム画面の収支円グラフを再計算
        ref.read(bpPieChartStateProvider.notifier).bpPieChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
        // updateState();
        // 総資産額の再計算
        ref.read(totalAssetsStateProvider.notifier).calcTotalAssets();
        // カレンダーのイベントを更新
        ref.read(calendarEventStateProvider.notifier).fetchCalendarEvent();
        // 統計の円グラフを更新
        ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
        ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
        ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
        ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        positiveSnackBar(context, '$largeCategoryを追加しました！');
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$largeCategoryの追加'),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          AppIconButton(
            icon: Icons.check,
            color: positiveIconColor,
            function: () async {
              await addEvent();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  AppPriceTextField(
                    controller: priceController.value,
                    textChange: (text) => price.value = text,
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(DateFormat.MMMEd('ja').format(date.value)),
                    leading: const Icon(Icons.calendar_today),
                    onTap: () async => date.value = await selectDate(context, date.value),
                  ),
                  const Divider(),
                  AppDropDownButton(
                    value: smallCategory.value,
                    function: (value) => smallCategory.value = value!,
                    item: largeCategory == '収入' ? incomeCategoryList : spendingCategoryList,
                    icon: const Icon(Icons.category),
                  ),
                  const Divider(),
                  AppDropDownButton(
                    value: paymentUser.value,
                    function: (value) => paymentUser.value = value!,
                    item: ref.watch(paymentUserProvider),
                    icon: const Icon(Icons.person),
                  ),
                  const Divider(),
                  AppMemoTextField(
                    controller: memoController.value,
                    textChange: (text) => memo.value = text,
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
