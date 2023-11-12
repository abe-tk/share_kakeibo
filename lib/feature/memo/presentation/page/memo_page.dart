import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class MemoPage extends ConsumerWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memo = ref.watch(memoProvider);
    final memoNotifier = ref.watch(memoProvider.notifier);
    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            memo.when(
              loading: () => const SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => const SliverFillRemaining(
                child: Center(
                  child: Text('読み込みに失敗しました。'),
                ),
              ),
              data: (data) => SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: data.length + 1,
                  (context, index) {
                    if (index == data.length) {
                      return (data.isEmpty)
                          ? const NonDataCase(
                              text: 'メモ',
                              topPadding: 200,
                            )
                          : const Gap(120);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                      child: CustomShadowContainer(
                        onLongPress: () async {
                          final isDelete = await ConfirmDialog.show(
                            context: context,
                            title: '「${data[index].memo}」を削除しますか？',
                            confirmButtonText: '削除',
                            confirmButtonTextStyle: context.bodyMediumRed,
                          );
                          if (isDelete) {
                            try {
                              await memoNotifier.deleteMemo(id: data[index].id);
                              final snackbar = CustomSnackBar(
                                context,
                                msg: 'メモを削除しました',
                              );
                              scaffoldMessenger.showSnackBar(snackbar);
                            } catch (e) {
                              logger.e(e.toString());
                            }
                          }
                        },
                        child: ListTile(
                          title: Text(data[index].memo),
                          subtitle: Text(data[index].registerDate.mmmEd),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
