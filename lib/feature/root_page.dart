import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/enum/update_request_type.dart';
import 'package:share_kakeibo/importer.dart';
import 'package:share_kakeibo/util/ad_mob/presentation/widget/ad_banner.dart';
import 'package:share_kakeibo/util/forced_update/application/update_request_service.dart';
import 'package:share_kakeibo/util/forced_update/presentation/widget/update_dialog.dart';

class RootPage extends HookConsumerWidget {
  const RootPage({Key? key}) : super(key: key);

  // bottomNavに表示するページ
  static const _pages = [
    HomePage(),
    CalendarPage(),
    ChartPage(),
    MemoPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // bottomNavで選択されているページのindex
    final selectIndex = useState(0);

    final memo = ref.watch(memoProvider);

    // updateの確認
    final updateRequestType = ref.watch(updateRequestService).whenOrNull(
          skipLoadingOnRefresh: false,
          data: (updateRequestType) => updateRequestType,
        );

    // トラッキングの認否を確認
    Future<void> initPlugin(BuildContext context) async {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await Future.delayed(const Duration(milliseconds: 200), () async {
          await AppTrackingTransparency.requestTrackingAuthorization();
        });
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // トラッキングの許可を要求
      initPlugin(context);

      // アップデートがあった場合
      if (updateRequestType == UpdateRequestType.cancelable ||
          updateRequestType == UpdateRequestType.forcibly) {
        // updateの案内を勝手に閉じて欲しくないのでbarrierDismissibleはfalse
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return UpdateDialog(
              updateRequestType: updateRequestType,
            );
          },
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          _pages[selectIndex.value],
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 36),
              child: AdBanner(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomFab(
        selectIndex: () => selectIndex.value = 3,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _BottomNavItem(
              icon: const Icon(Icons.home_outlined),
              isActive: selectIndex.value == 0,
              onTaped: () => selectIndex.value = 0,
            ),
            _BottomNavItem(
              icon: const Icon(Icons.calendar_today_outlined),
              isActive: selectIndex.value == 1,
              onTaped: () => selectIndex.value = 1,
            ),
            const Expanded(
              child: SizedBox(height: 50),
            ),
            _BottomNavItem(
              icon: const Icon(Icons.pie_chart_outline),
              isActive: selectIndex.value == 2,
              onTaped: () => selectIndex.value = 2,
            ),
            _BottomNavItem(
              icon: Stack(
                children: [
                  const Icon(Icons.featured_play_list_outlined),
                  CustomBatch(
                    length: memo.when(
                      loading: () => 0,
                      error: (error, stack) => 0,
                      data: (data) => data.length,
                    ),
                  ),
                ],
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

class _BottomNavItem extends StatelessWidget {
  final Widget icon;
  final bool isActive;
  final VoidCallback onTaped;

  const _BottomNavItem({
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
                      color: Colors.white,
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
