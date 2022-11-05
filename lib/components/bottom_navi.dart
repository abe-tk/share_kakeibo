// constant
import 'package:share_kakeibo/constant/colors.dart';
import 'package:share_kakeibo/state/memo/memo_state.dart';
// view
import 'package:share_kakeibo/view/home/home_page.dart';
import 'package:share_kakeibo/view/calendar/calendar_page.dart';
import 'package:share_kakeibo/view/chart/chart_page.dart';
import 'package:share_kakeibo/view/memo/memo_page.dart';
// view_model
import 'package:share_kakeibo/view_model/event/add_event_view_model.dart';
import 'package:share_kakeibo/view_model/memo/memo_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class BottomNavi extends StatefulHookConsumerWidget {
  const BottomNavi({Key? key}) : super(key: key);

  @override
  _BottomNaviState createState() => _BottomNaviState();
}

class _BottomNaviState extends ConsumerState<BottomNavi> {

  final _pages = [
    const HomePage(),
    const CalendarPage(),
    null,
    const ChartPage(),
    const MemoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final selectIndex = useState(0);
    return Scaffold(
      body: _pages[selectIndex.value],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: fabBackGroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.edit),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
            ),
            builder: (BuildContext context) {
              return SizedBox(
                height: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 10,left: 60, right: 60, bottom: 10),
                      child: Divider(thickness: 3),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.add),
                            title: const Text('収入の追加'),
                            onTap: () async {
                              await ref.read(addEventViewModelProvider.notifier).fetchPaymentUser();
                              Navigator.pushNamed(context, '/addIncomeEventPage');
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.remove),
                            title: const Text('支出の追加'),
                            onTap: () async {
                              await ref.read(addEventViewModelProvider.notifier).fetchPaymentUser();
                              Navigator.pushNamed(context, '/addSpendingEventPage');
                            },
                          ),
                          const Divider(),
                          ListTile(
                            leading: const Icon(Icons.edit),
                            title: const Text('メモの追加'),
                            onTap: () {
                              selectIndex.value = 4;
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    title: const Text("メモの追加"),
                                    children: [
                                      SimpleDialogOption(
                                        onPressed: () => Navigator.pop(context),
                                        child: ListTile(
                                          title: TextField(
                                            cursorColor: Colors.grey,
                                            autofocus: true,
                                            decoration: const InputDecoration(
                                              hintText: 'メモ',
                                              border: InputBorder.none,
                                            ),
                                            onChanged: (text) {
                                              ref.read(memoViewModelProvider.notifier).setMemo(text);
                                            },
                                          ),
                                          leading: const Icon(Icons.note),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          SimpleDialogOption(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text("CANCEL"),
                                          ),
                                          SimpleDialogOption(
                                            onPressed: () async {
                                              try {
                                                await ref.read(memoViewModelProvider.notifier).addMemo();
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    backgroundColor: positiveSnackBarColor,
                                                    behavior: SnackBarBehavior.floating,
                                                    content: const Text('メモを追加しました！'),
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
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                              ref.read(memoViewModelProvider.notifier).clearMemo();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'ホーム',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'カレンダー',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: '入力',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            activeIcon: Icon(Icons.pie_chart),
            label: '統計',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                const Icon(Icons.featured_play_list_outlined),
                Visibility(
                  visible: (ref.watch(memoProvider).isNotEmpty) ? true : false,
                  child: Positioned(
                    right: 0,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: batchBackGroundColor,
                        shape: BoxShape.circle,
                      ),
                      width: 16.0,
                      height: 16.0,
                      child: Center(
                        child: Text(
                          '${ref.watch(memoProvider).length}',
                          style: const TextStyle().copyWith(
                            color: batchTextColor,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      constraints: const BoxConstraints(
                        minHeight: 12,
                        minWidth: 12,
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
              ],
            ),
            activeIcon: const Icon(Icons.featured_play_list_rounded),
            label: 'メモ',
          ),
        ],
        currentIndex: selectIndex.value,
        onTap: (index) {
          switch (index) {
            case 2:
              break;
            default:
              selectIndex.value = index;
              break;
          }
        },
        backgroundColor: bottomNavigationBackGroundColor,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: selectedItemColor,
        unselectedItemColor: unSelectedItemColor,
      ),
    );
  }
}
