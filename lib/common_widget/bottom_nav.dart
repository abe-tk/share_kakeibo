import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class BottomNav extends HookConsumerWidget {
  const BottomNav({Key? key}) : super(key: key);

  static const _pages = [
    HomePage(),
    CalendarPage(),
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
        selectIndex: () => selectIndex.value = 3,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BottomNavItem(
              icon: Icon(Icons.home_outlined),
              isActive: selectIndex.value == 0,
              onTaped: () => selectIndex.value = 0,
            ),
            BottomNavItem(
              icon: Icon(Icons.calendar_today_outlined),
              isActive: selectIndex.value == 1,
              onTaped: () => selectIndex.value = 1,
            ),
            const Expanded(
              child: SizedBox(height: 50),
            ),
            BottomNavItem(
              icon: Icon(Icons.pie_chart_outline),
              isActive: selectIndex.value == 2,
              onTaped: () => selectIndex.value = 2,
            ),
            BottomNavItem(
              icon: MemoBatch(
                isNotEmpty: ref.watch(memoProvider).isNotEmpty,
                length: ref.watch(memoProvider).length,
              ),
              isActive: selectIndex.value == 3,
              onTaped: () => selectIndex.value = 3,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final Widget icon;
  final bool isActive;
  final VoidCallback onTaped;

  const BottomNavItem({
    Key? key,
    required this.icon,
    required this.isActive,
    required this.onTaped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 50,
        alignment: Alignment.center,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Visibility(
              visible: isActive,
              child: Container(
                height: 40,
                width: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                    ),
                    BoxShadow(
                      color: CustomColor.bdColor,
                      offset: Offset(0.0, 3.0),
                      blurRadius: 3.0,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: onTaped,
              child: icon,
            ),
          ],
        ),
      ),
    );
  }
}
