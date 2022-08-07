/// model
import 'package:share_kakeibo/model/event.dart';

/// view_model
import 'package:share_kakeibo/view_model/edit_event/edit_event_view_model.dart';
import 'package:share_kakeibo/view_model/home/home_view_model.dart';
import 'package:share_kakeibo/view_model/calendar/calendar_view_model.dart';
import 'package:share_kakeibo/view_model/chart/chart_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class EditIncomePage extends StatefulHookConsumerWidget {
  EditIncomePage(this.event);
  final Event event;

  @override
  _EditIncomePageState createState() => _EditIncomePageState(event);
}

class _EditIncomePageState extends ConsumerState<EditIncomePage> {
  _EditIncomePageState(this.event);

  final Event event;

  @override
  void initState() {
    super.initState();
    ref.read(editEventViewModel).fetchPaymentUser();
    ref.read(editEventViewModel).setEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    final editViewModel = ref.watch(editEventViewModel);
    final incomeCategory = useState(editViewModel.incomeCategory);
    final incomePaymentUser = useState(editViewModel.incomePaymentUser);
    final selectedDate = useState(editViewModel.selectedDate);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            '収入の編集',
            style: TextStyle(color: Color(0xFF725B51)),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFFFCF6EC),
          elevation: 1,
          iconTheme: const IconThemeData(color: Color(0xFF725B51)),
          actions: [
            IconButton(
              onPressed: () async {
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
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(editViewModel.roomCode)
                                  .collection('events')
                                  .doc(event.id)
                                  .delete();
                              ref.read(homeViewModelProvider).assetsCalc();
                              ref.read(calendarViewModelProvider).fetchEvent();
                              ref.read(chartViewModelProvider).calc();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text('収入を削除しました'),
                                ),
                              );
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete, color: Colors.red,),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await ref
                      .read(editEventViewModel)
                      .incomeEventUpdate();

                  ref.read(homeViewModelProvider).assetsCalc();
                  ref.read(calendarViewModelProvider).fetchEvent();
                  ref.read(chartViewModelProvider).calc();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('収入を編集しました！'),
                    ),
                  );
                } catch (e) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(e.toString()),
                  );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBar);
                }
                // selectedDate.value = DateTime(DateTime.now().year,
                //     DateTime.now().month, DateTime.now().day);
              },
              icon: const Icon(Icons.check,color: Colors.green,),
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
                          controller: editViewModel.priceController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'price',
                            border: InputBorder.none,
                          ),
                          onChanged: (text) {
                            editViewModel.setPrice(text);
                          },
                        ),
                        leading: const Icon(Icons.currency_yen),
                        trailing: const Text('円'),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: Text(
                          DateFormat.MMMEd('ja').format(selectedDate.value)),
                      leading: const Icon(Icons.calendar_today),
                      onTap: () async {
                        await editViewModel.selectDate(context);
                        selectedDate.value = editViewModel.selectedDate;
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: DropdownButton<String>(
                        value: incomeCategory.value,
                        onChanged: (String? value) {
                          incomeCategory.value = value!;
                          editViewModel.setIncomeCategory(value);
                        },
                        items: editViewModel.incomeCategoryList
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
                        value: incomePaymentUser.value,
                        onChanged: (String? value) {
                          incomePaymentUser.value = value!;
                          editViewModel.setIncomePaymentUser(value);
                        },
                        items: editViewModel.paymentUserList
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
                        controller: editViewModel.memoController,
                        decoration: const InputDecoration(
                          hintText: 'memo',
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          editViewModel.setMemo(text);
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
