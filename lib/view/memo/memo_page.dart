// components
import 'package:share_kakeibo/components/drawer_menu.dart';
// constant
import 'package:share_kakeibo/constant/colors.dart';
// model
import 'package:share_kakeibo/model/memo/memo.dart';
// state
import 'package:share_kakeibo/state/memo/memo_state.dart';
// view_model
import 'package:share_kakeibo/view_model/memo/memo_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';

class MemoPage extends StatefulHookConsumerWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends ConsumerState<MemoPage> {
  @override
  void initState() {
    super.initState();
    ref.read(memoViewModelProvider.notifier).fetchMemo();
  }

  @override
  Widget build(BuildContext context) {
    List<Memo> memos = ref.watch(memoViewModelProvider);
    final memoViewModelNotifier = ref.watch(memoViewModelProvider.notifier);
    final isComplete = useState(false);
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
                        ? const NoMemoCase()
                        : const SizedBox(height: 50);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: boxColor,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: boxShadowColor,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        checkColor: checkboxChekColor,
                        activeColor: checkboxActiveColor,
                        value: memos[index].completed,
                        onChanged: (value) {
                          memoViewModelNotifier.toggle(memos[index].id);
                          isComplete.value = memoViewModelNotifier.isCompletedChange();
                        },
                        title: Text(
                          memos[index].memo,
                          style: TextStyle(
                            decoration: (memos[index].completed == true)
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(DateFormat.MMMEd('ja').format(memos[index].date)),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: isComplete.value,
        child: SizedBox(
          width: 50,
          child: FloatingActionButton(
            child: Icon(Icons.delete, color: memoPageFabIconColor,),
            backgroundColor: memoPageFabBackGroundColor,
            onPressed: () async {
              try {
                await memoViewModelNotifier.removeMemo();
                ref.read(memoProvider.notifier).setMemo();
                isComplete.value = memoViewModelNotifier.isCompletedChange();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: negativeSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: const Text('メモを削除しました'),
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
        ),
      ),
    );
  }
}

class NoMemoCase extends ConsumerWidget {
  const NoMemoCase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const SizedBox(height: 60),
        SizedBox(
          width: 150,
          child: Image.asset('assets/image/app_theme_gray.png'),
        ),
        const Text('メモが存在しません', style: TextStyle(fontWeight: FontWeight.bold,),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('「', style: TextStyle(color: detailTextColor),),
            Icon(Icons.edit, size: 16,color: detailTextColor,),
            Text('入力」からメモを追加してください', style: TextStyle(color: detailTextColor),),
          ],
        ),
      ],
    );
  }
}
