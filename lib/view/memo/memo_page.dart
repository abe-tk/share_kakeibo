import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class MemoPage extends HookConsumerWidget {
  const MemoPage({Key? key}) : super(key: key);

  Future<void> removeMemo(BuildContext context, WidgetRef ref) async {
    try {
      await ref.watch(memoProvider.notifier).removeMemo();
      negativeSnackBar(context, 'メモを削除しました');
    } catch (e) {
      negativeSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Memo> memos = ref.watch(memoProvider);
    final memoNotifier = ref.watch(memoProvider.notifier);
    return Scaffold(
      appBar: ActionAppBar(
        title: 'メモ',
        icon: Icons.delete,
        iconColor: Colors.red,
        function: () => removeMemo(context, ref),
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: memos.length + 1,
            itemBuilder: (context, index) {
              if (index == memos.length) {
                return (memos.isEmpty)
                    ? const NoDataCaseImg(text: 'メモ', height: 60)
                    : const SizedBox(height: 50);
              }
              return MemoList(
                completed: memos[index].completed,
                memo: memos[index].memo,
                date: memos[index].date,
                function: (value) => memoNotifier.toggle(memos[index].id),
              );
            },
          ),
        ),
      ),
    );
  }
}
