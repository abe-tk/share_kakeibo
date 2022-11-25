import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

class MemoPage extends HookConsumerWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Memo> memos = ref.watch(memoProvider);
    final memoNotifier = ref.watch(memoProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('メモ'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBarBackGroundColor,
        bottom: PreferredSize(
          child: Container(
            height: 0.1,
            color: appBarBottomLineColor,
          ),
          preferredSize: const Size.fromHeight(0.1),
        ),
        actions: [
          AppIconButton(
            icon: Icons.delete,
            color: negativeIconColor,
            function: () async {
              try {
                await memoNotifier.removeMemo();
                negativeSnackBar(context, 'メモを削除しました');
              } catch (e) {
                negativeSnackBar(context, e.toString());
              }
            },
          ),
        ],
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: memos.length + 1,
                itemBuilder: (context, index) {
                  if (index == memos.length) {
                    return (memos.isEmpty)
                        ? const NoDataCase(text: 'メモ', height: 60)
                        : const SizedBox(height: 50);
                  }
                  return AppMemoList(
                    completed: memos[index].completed,
                    memo: memos[index].memo,
                    date: memos[index].date,
                    function: (value) => memoNotifier.toggle(memos[index].id),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
