import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class BottomNavi extends HookConsumerWidget {
  const BottomNavi({Key? key}) : super(key: key);

  static const _pages = [
    HomePage(),
    CalendarPage(),
    null,
    ChartPage(),
    MemoPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectIndex = useState(0);
    return Scaffold(
      body: _pages[selectIndex.value],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Fab(
        selectIndex: () => selectIndex.value = 4,
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
            icon: MemoBatch(
              isNotEmpty: ref.watch(memoProvider).isNotEmpty,
              length: ref.watch(memoProvider).length,
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
