// constant
import 'package:share_kakeibo/constant/colors.dart';
// firebase
import 'package:share_kakeibo/firebase/event_fire.dart';
// model
import 'package:share_kakeibo/model/event.dart';
// state
import 'package:share_kakeibo/state/event/event_state.dart';
// view_model
import 'package:share_kakeibo/state/chart/bp_pie_chart_state.dart';
import 'package:share_kakeibo/state/price/total_assets_state.dart';
import 'package:share_kakeibo/view_model/calendar/calendar_view_model.dart';
import 'package:share_kakeibo/view_model/calendar/detail_event_view_model.dart';
import 'package:share_kakeibo/state/chart/income_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/chart/spending_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/chart/income_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/chart/spending_category_pie_chart_state.dart';
import 'package:share_kakeibo/view_model/event/edit_event_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';



class EditEventPage extends StatefulHookConsumerWidget {
  EditEventPage(this.event);
  final Event event;

  @override
  _EditEventPageState createState() => _EditEventPageState(event);
}

class _EditEventPageState extends ConsumerState<EditEventPage> {
  _EditEventPageState(this.event);
  final Event event;

  @override
  Widget build(BuildContext context) {
    final editEventState = ref.watch(editEventViewModelProvider);
    final editEventNotifier = ref.watch(editEventViewModelProvider.notifier);
    final smallCategory = useState(editEventState['smallCategory']);
    final paymentUser = useState(editEventState['paymentUser']);
    final selectedDate = useState(editEventState['date']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${event.largeCategory}の編集',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
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
                            await deleteEventFire(editEventNotifier.roomCode, event.id);
                            await ref.read(eventProvider.notifier).setEvent();
                            // ホーム画面の収支円グラフを再計算
                            ref.read(bpPieChartStateProvider.notifier).bpPieChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                            // 総資産額の再計算
                            ref.read(totalAssetsStateProvider.notifier).calcTotalAssets();
                            // カレンダーのイベントを更新
                            ref.read(calendarViewModelProvider.notifier).fetchCalendarEvent();
                            ref.read(detailEventViewModelProvider.notifier).fetchDetailEvent();
                            // 統計の円グラフを更新
                            ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                            ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                            ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                            ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
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
                        },
                      ),
                    ],
                  );
                },
              );
            },
            icon: Icon(Icons.delete, color: negativeIconColor,),
          ),
          IconButton(
            onPressed: () async {
              try {
                await editEventNotifier.updateEvent();
                // ホーム画面の収支円グラフを再計算
                ref.read(bpPieChartStateProvider.notifier).bpPieChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                // 総資産額の再計算
                ref.read(totalAssetsStateProvider.notifier).calcTotalAssets();
                // カレンダーのイベントを更新
                ref.read(calendarViewModelProvider.notifier).fetchCalendarEvent();
                // 統計の円グラフを更新
                ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: positiveSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: Text('${event.largeCategory}を編集しました！'),
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
            },
            icon: Icon(Icons.check,color: positiveIconColor,),
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
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: ListTile(
                      title: TextField(
                        controller: editEventNotifier.priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          editEventNotifier.setPrice(text);
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
                      await editEventNotifier.selectDate(context);
                      selectedDate.value = editEventState['date'];
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: DropdownButton<String>(
                      value: smallCategory.value,
                      onChanged: (String? value) {
                        smallCategory.value = value!;
                        editEventNotifier.setSmallCategory(value);
                      },
                      items:  (event.largeCategory == '収入'
                          ? editEventNotifier.incomeCategoryList
                          : editEventNotifier.spendingCategoryList)
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
                      value: paymentUser.value,
                      onChanged: (String? value) {
                        paymentUser.value = value!;
                        editEventNotifier.setPaymentUser(value);
                      },
                      items: editEventNotifier.paymentUserList
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
                      controller: editEventNotifier.memoController,
                      decoration: const InputDecoration(
                        hintText: 'メモ',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        editEventNotifier.setMemo(text);
                      },
                    ),
                    leading: const Icon(Icons.featured_play_list_rounded),
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
