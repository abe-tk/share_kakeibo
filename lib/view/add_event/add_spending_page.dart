/// view_model
import 'package:share_kakeibo/view_model/home/home_view_model.dart';
import 'package:share_kakeibo/view_model/calendar/calendar_view_model.dart';
import 'package:share_kakeibo/view_model/chart/chart_view_model.dart';
import 'package:share_kakeibo/view_model/add_event/add_event_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AddSpendingPage extends StatefulHookConsumerWidget {
  const AddSpendingPage({Key? key}) : super(key: key);

  @override
  _AddSpendingPageState createState() => _AddSpendingPageState();
}

class _AddSpendingPageState extends ConsumerState<AddSpendingPage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(addEventViewModelProvider).fetchPaymentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(addEventViewModelProvider);
    final spendingCategory = useState('未分類');
    final spendingPaymentUser = useState(model.name);
    final selectedDate = useState(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '支出の追加',
            style: TextStyle(color: Color(0xFF725B51)),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFFCF6EC),
          elevation: 1,
          iconTheme: const IconThemeData(color: Color(0xFF725B51)),
          actions: [
            IconButton(
              icon: const Icon(Icons.check,color: Colors.green,),
              onPressed: () async {
                try {
                  await ref
                      .read(addEventViewModelProvider)
                      .addSpendingEvent();
                  ref.read(homeViewModelProvider).assetsCalc();
                  ref.read(calendarViewModelProvider).fetchEvent();
                  ref.read(chartViewModelProvider).calc();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('支出を追加しました！'),
                    ),
                  );
                } catch (e) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                selectedDate.value = DateTime(DateTime.now().year,
                    DateTime.now().month, DateTime.now().day);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: ListTile(
                        title: TextField(
                          autofocus: true,
                          controller:
                          ref.watch(addEventViewModelProvider).priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'price',
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            ref.read(addEventViewModelProvider).setPrice(text);
                          },
                        ),
                        leading: const Icon(Icons.currency_yen),
                        trailing: const Text('円'),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title:
                      Text(DateFormat.MMMEd('ja').format(selectedDate.value)),
                      leading: const Icon(Icons.calendar_today),
                      onTap: () async {
                        await ref
                            .read(addEventViewModelProvider)
                            .selectDate(context);
                        selectedDate.value =
                            ref.read(addEventViewModelProvider).selectedDate;
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: DropdownButton<String>(
                        value: spendingCategory.value,
                        onChanged: (String? value) {
                          spendingCategory.value = value!;
                          ref
                              .read(addEventViewModelProvider)
                              .setSpendingCategory(value);
                        },
                        items: model.spendingCategoryList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      leading: const Icon(Icons.category),
                    ),
                    const Divider(),
                    ListTile(
                      title: DropdownButton<String>(
                        value: spendingPaymentUser.value,
                        onChanged: (String? value) {
                          spendingPaymentUser.value = value!;
                          ref
                              .read(addEventViewModelProvider)
                              .setSpendingPaymentUser(value);
                        },
                        items: model.spendingPaymentUserList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      leading: const Icon(Icons.person),
                    ),
                    const Divider(),
                    ListTile(
                      title: TextField(
                        controller:
                        ref.watch(addEventViewModelProvider).memoController,
                        decoration: const InputDecoration(
                          hintText: 'memo',
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          ref.read(addEventViewModelProvider).setMemo(text);
                        },
                      ),
                      leading: const Icon(Icons.note),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
