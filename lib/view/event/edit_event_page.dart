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
    final smallCategory = useState(event.smallCategory);
    final paymentUser = useState(event.paymentUser);
    final memo = useState(event.memo);
    final memoController = useState(TextEditingController(text: event.memo));

    Future<void> updateEvent() async {
      try {
        await EventFire().updateEventFire(
          ref.watch(roomCodeProvider),
          event,
          date.value,
          price.value,
          smallCategory.value,
          memo.value,
          DateTime(date.value.year, date.value.month),
          paymentUser.value,
        );
        await updateEventState(ref, DateTime(DateTime.now().year, DateTime.now().month));
        Navigator.of(context).pop();
        positiveSnackBar(context, '${event.largeCategory}を編集しました！');
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
            title: Text("${DateFormat.MMMEd('ja').format(event.date)}\n${event.smallCategory}：${event.price} 円\n削除しますか？"),
            actions: [
              TextButton(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: const Text("OK"),
                onPressed: () async {
                  try {
                    await EventFire().deleteEventFire(ref.watch(roomCodeProvider), event.id);
                    await updateEventState(ref, DateTime(DateTime.now().year, DateTime.now().month));
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    negativeSnackBar(context, '${event.largeCategory}を削除しました');
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
      appBar: TwoActionAppBar(
        title: '${event.largeCategory}の編集',
        firstIcon: Icons.delete,
        firstIconColor: CustomColor.negativeIconColor,
        firstFunction: () async => deleteEvent(),
        secondIcon: Icons.check,
        secondIconColor: CustomColor.positiveIconColor,
        secondFunction: () async => updateEvent(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  PriceTextField(
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
                    item: event.largeCategory == '収入' ? Category.incomeCategory : Category.spendingCategory,
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
                  MemoTextField(
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
