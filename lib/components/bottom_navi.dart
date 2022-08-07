/// components
import 'package:share_kakeibo/components/fab.dart';

/// view
import 'package:share_kakeibo/view/home/home_page.dart';
import 'package:share_kakeibo/view/calendar/calendar_page.dart';
import 'package:share_kakeibo/view/chart/chart_page.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/view/memo/memo_page.dart';

import 'drawer_menu.dart';

class BottomNavi extends HookConsumerWidget {
  BottomNavi({Key? key}) : super(key: key);

  final _pages = [
    const HomePage(),
    const CalendarPage(),
    const ChartPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _currentIndex = useState(0);
    return Scaffold(
      appBar: AppBar(
        title: (_currentIndex.value == 0)
            ? const Text(
                'ホーム',
                style: TextStyle(color: Color(0xFF725B51)),
              )
            : (_currentIndex.value == 1)
                ? const Text(
                    'カレンダー',
                    style: TextStyle(color: Color(0xFF725B51)),
                  )
                : const Text(
                    '統計',
                    style: TextStyle(color: Color(0xFF725B51)),
                  ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: (_currentIndex.value != 2) ? 1 : 1,
        iconTheme: const IconThemeData(
          color: Color(0xFF725B51),
        ),
        actions: [
          IconButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                fullscreenDialog: true,
                builder: (context) {
                  return const MemoPage();
                },
              ),
            );
          }, icon: const Icon(Icons.note_alt))
        ],
      ),
      drawer: const DrawerMenu(),
      body: IndexedStack(
        index: _currentIndex.value,
        children: _pages,
      ),
      floatingActionButton: const Fab(),
      bottomNavigationBar: SizedBox(
        child: BottomNavigationBar(
          currentIndex: _currentIndex.value,
          backgroundColor: const Color(0xFFFCF6EC),
          onTap: (int index) {
            _currentIndex.value = index;
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'ホーム',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'カレンダー',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: '統計',
            ),
          ],
          selectedIconTheme: const IconThemeData(
              size: 30, color: Color(0xFF725B51), opacity: 1),
          unselectedIconTheme: const IconThemeData(
              size: 25, color: Color(0xFF725B51), opacity: 0.5),
        ),
      ),
    );
  }
}
