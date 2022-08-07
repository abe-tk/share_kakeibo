/// view
import 'package:share_kakeibo/view/add_event/add_income_page.dart';
import 'package:share_kakeibo/view/add_event/add_spending_page.dart';
import 'package:share_kakeibo/view/memo/memo_page.dart';

/// view_model
import 'package:share_kakeibo/view_model/add_event/add_event_view_model.dart';
import 'package:share_kakeibo/view_model/memo/memo_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Fab extends HookConsumerWidget {
  const Fab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
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
                    child: Divider(thickness: 3,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('収入の追加'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AddIncomePage();
                                },
                              ),
                            );
                            ref.read(addEventViewModelProvider).clearInputData();
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.remove),
                          title: const Text('支出の追加'),
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const AddSpendingPage();
                                },
                              ),
                            );
                            ref.read(addEventViewModelProvider).clearInputData();
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('メモの追加'),
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) {
                                  return const MemoPage();
                                },
                              ),
                            );
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
                                          autofocus: true,
                                          controller: ref.read(memoViewModelProvider.notifier).memoController,
                                          decoration: const InputDecoration(
                                            labelText: 'メモ',
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
                                              ref.read(memoViewModelProvider.notifier).fetchMemo();
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.green,
                                                  content: Text('メモを追加しました！'),
                                                ),
                                              );
                                            } catch (e) {
                                              final snackBar = SnackBar(
                                                backgroundColor: Colors.red,
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
    );
  }
}
