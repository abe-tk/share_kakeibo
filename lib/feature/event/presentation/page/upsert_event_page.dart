import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/importer.dart';

class UpsertEventPage extends HookConsumerWidget {
  const UpsertEventPage({
    Key? key,
    required this.largeCategory,
    this.event,
  }) : super(key: key);
  final String largeCategory;
  final Event? event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 金額
    final price = useState(event?.price ?? '');
    final priceController = useTextEditingController(
      text: event?.price ?? '',
    );

    // 日付
    final date = useState(
      event?.date ??
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
    );

    // カテゴリー
    final smallCategory = useState(
      event?.smallCategory ?? '未分類',
    );

    // 支払い元
    final paymentUser = useState(
      event?.paymentUser ??
          ref.watch(userInfoProvider).whenOrNull(
                data: (data) => data!.userName,
              ),
    );

    // メモ
    final memo = useState(event?.memo ?? '');
    final memoController = useTextEditingController(
      text: event?.memo ?? '',
    );

    final roomCode =
        ref.watch(roomCodeProvider(ref.watch(uidProvider))).whenOrNull(
              data: (data) => data,
            );

    final eventData = ref.watch(eventProvider).whenOrNull(
          skipLoadingOnRefresh: false,
          data: (data) => data,
        );

    Future<void> addEvent() async {
      try {
        addEventValidation(price.value);
        await ref.read(eventProvider.notifier).createEvent(
              roomCode: roomCode!,
              date: date.value,
              price: price.value,
              largeCategory: largeCategory,
              smallCategory: smallCategory.value,
              memo: memo.value,
              currentMonth: DateTime(date.value.year, date.value.month),
              paymentUser: paymentUser.value.toString(),
            );
        ref.read(totalAssetsStateProvider.notifier).calcTotalAssets(eventData!);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        positiveSnackBar(context, '$largeCategoryを追加しました！');
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    Future<void> updateEvent() async {
      try {
        addEventValidation(price.value);
        await ref.read(eventProvider.notifier).updateEvent(
              roomCode: roomCode!,
              event: event!,
              date: date.value,
              price: price.value,
              smallCategory: smallCategory.value,
              memo: memo.value,
              currentMonth: DateTime(date.value.year, date.value.month),
              paymentUser: paymentUser.value.toString(),
            );
        ref.read(totalAssetsStateProvider.notifier).calcTotalAssets(eventData!);
        Navigator.of(context).pop();
        positiveSnackBar(context, '$largeCategoryを編集しました！');
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    Future<void> deleteEvent() async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return AlertDialog(
            title: Text(
                "${DateFormat.MMMEd('ja').format(event!.date)}\n${event!.smallCategory}：${event!.price} 円\n削除しますか？"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () async {
                  try {
                    await ref.read(eventProvider.notifier).deleteEvent(
                          roomCode: roomCode!,
                          id: event!.id,
                        );
                    ref
                        .read(totalAssetsStateProvider.notifier)
                        .calcTotalAssets(eventData!);

                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    negativeSnackBar(context, '${event!.largeCategory}を削除しました');
                  } catch (e) {
                    negativeSnackBar(context, e.toString());
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: CustomAppBar(
        title:
            event == null ? '$largeCategoryの追加' : '${event!.largeCategory}の編集',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                UpsertEventItem(
                  icon: const Icon(Icons.currency_yen),
                  hintText: '0',
                  controller: priceController,
                  textChange: (text) => price.value = text,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                ),
                UpsertEventItem(
                  icon: const Icon(Icons.calendar_today),
                  date: DateFormat.MMMEd('ja').format(date.value),
                  selectDate: () async =>
                      date.value = await selectDate(context, date.value),
                ),
                UpsertEventItem(
                  icon: const Icon(Icons.category),
                  initialItem: smallCategory.value,
                  items: largeCategory == '収入'
                      ? Category.incomeCategory
                      : Category.spendingCategory,
                  selectItem: (value) => smallCategory.value = value!,
                ),
                UpsertEventItem(
                  icon: const Icon(Icons.person),
                  initialItem: paymentUser.value.toString(),
                  items: ref.watch(paymentUserProvider),
                  selectItem: (value) => paymentUser.value = value!,
                ),
                UpsertEventItem(
                  icon: const Icon(Icons.featured_play_list_rounded),
                  hintText: 'メモ',
                  controller: memoController,
                  textChange: (text) => memo.value = text,
                ),
                const SizedBox(height: 32),
                event == null
                    ? CustomElevatedButton(
                        text: '保存',
                        onTaped: () async => await addEvent(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomElevatedButton(
                            text: '削除',
                            textColor: Colors.white,
                            buttonColor: Colors.red,
                            onTaped: () async => deleteEvent(),
                          ),
                          CustomElevatedButton(
                            text: '保存',
                            onTaped: () async => await updateEvent(),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}