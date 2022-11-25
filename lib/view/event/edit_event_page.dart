import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/impoter.dart';

class EditEventPage extends HookConsumerWidget {
  const EditEventPage({Key? key, required this.event}) : super(key: key);
  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = useState(event.price);
    final priceController = useState(TextEditingController(text: event.price));
    final date = useState(event.date);
    final smallCategory = useState('未分類');
    final paymentUser = useState(event.paymentUser);
    final memo = useState(event.memo);
    final memoController = useState(TextEditingController(text: event.memo));

    void updateState() {
      // ホーム画面の収支円グラフを再計算
      ref.read(bpPieChartStateProvider.notifier).bpPieChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
      // 総資産額の再計算
      ref.read(totalAssetsStateProvider.notifier).calcTotalAssets();
      // カレンダーのイベントを更新
      ref.read(calendarEventStateProvider.notifier).fetchCalendarEvent();
      ref.read(detailEventStateProvider.notifier).fetchDetailEvent();
      // 統計の円グラフを更新
      ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
      ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
      ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
      ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
    }

    Future<void> updateEvent() async {
      try {
        addEventValidation(price.value);
        await updateEventFire(
          ref.watch(roomCodeProvider),
          event,
          date.value,
          price.value,
          event.largeCategory,
          smallCategory.value,
          memo.value,
          DateTime(date.value.year, date.value.month),
          paymentUser.value,
        );
        await ref.read(eventProvider.notifier).setEvent();
        updateState();
        Navigator.of(context).pop();
        positiveSnackBar(context, '${event.largeCategory}を編集しました！');
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    Future<void> deleteEvent() async {
      try {
        await deleteEventFire(ref.watch(roomCodeProvider), event.id);
        await ref.read(eventProvider.notifier).setEvent();
        updateState();
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: negativeSnackBarColor,
            behavior: SnackBarBehavior.floating,
            content: Text('${event.largeCategory}を削除しました'),
          ),
        );
      } catch (e) {
        final snackBar = SnackBar(
          backgroundColor: negativeSnackBarColor,
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        );
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBar);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${event.largeCategory}の編集',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          AppIconButton(
            icon: Icons.delete,
            color: negativeIconColor,
            function: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) {
                  return AlertDialog(
                    title: Text("${DateFormat.MMMEd('ja').format(event.date)}\n${event.smallCategory}：${event.price} 円\n削除しますか？"),
                    actions: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text("OK"),
                        onPressed: () async => deleteEvent(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          AppIconButton(
            icon: Icons.check,
            color: positiveIconColor,
            function: () async => updateEvent(),
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
                    item: event.largeCategory == '収入' ? incomeCategoryList : spendingCategoryList,
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
