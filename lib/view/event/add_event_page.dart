// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/event/calendar_event_state.dart';
import 'package:share_kakeibo/state/pie_chart/bp_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/income_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/price/total_assets_state.dart';
import 'package:share_kakeibo/state/pie_chart/income_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_category_pie_chart_state.dart';
// view_model
import 'package:share_kakeibo/view_model/event/add_event_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class AddEventPage extends StatefulHookConsumerWidget {
  const AddEventPage({Key? key, required this.largeCategory}) : super(key: key);
  final String largeCategory;

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends ConsumerState<AddEventPage> {
  @override
  void initState() {
    super.initState();
    ref.read(addEventViewModelProvider.notifier).setLargeCategory(widget.largeCategory);
  }

  @override
  Widget build(BuildContext context) {
    final addEventState = ref.watch(addEventViewModelProvider);
    final addEventNotifier = ref.watch(addEventViewModelProvider.notifier);
    final smallCategory = useState(addEventState['smallCategory']);
    final paymentUser = useState(addEventState['paymentUser']);
    final selectedDate = useState(addEventState['date']);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.largeCategory}の追加',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: positiveIconColor,
            ),
            onPressed: () async {
              try {
                await addEventNotifier.addEvent();
                // ホーム画面の収支円グラフを再計算
                ref.read(bpPieChartProvider.notifier).bpPieChartCalc();
                // 総資産額の再計算
                ref.read(totalAssetsProvider.notifier).calcTotalAssets();
                // カレンダーのイベントを更新
                ref.read(calendarEventProvider.notifier).fetchCalendarEvent();
                // 統計の円グラフを更新
                ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc();
                ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc();
                ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc();
                ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: positiveSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: Text('${widget.largeCategory}を追加しました！'),
                  ),
                );
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: negativeSnackBarColor,
                  behavior: SnackBarBehavior.floating,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
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
                  Container(
                    alignment: Alignment.center,
                    height: 100,
                    child: ListTile(
                      title: TextField(
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                        ),
                        onChanged: (text) {
                          addEventNotifier.setPrice(text);
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
                      await addEventNotifier.selectDate(context);
                      selectedDate.value = addEventState['date'];
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: DropdownButton<String>(
                      value: smallCategory.value,
                      onChanged: (String? value) {
                        smallCategory.value = value!;
                        addEventNotifier.setSmallCategory(value);
                      },
                      items: (widget.largeCategory == '収入'
                              ? addEventNotifier.incomeCategoryList
                              : addEventNotifier.spendingCategoryList)
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
                        addEventNotifier.setPaymentUser(value);
                      },
                      items: addEventNotifier.paymentUserList
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
                      decoration: const InputDecoration(
                        hintText: 'メモ',
                        border: InputBorder.none,
                      ),
                      onChanged: (text) {
                        addEventNotifier.setMemo(text);
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
