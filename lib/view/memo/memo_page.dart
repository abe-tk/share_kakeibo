/// view
import 'package:share_kakeibo/view_model/memo/memo_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MemoPage extends StatefulHookConsumerWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends ConsumerState<MemoPage> {

  @override
  void initState() {
    super.initState();
    ref.read(memoViewModelProvider).fetchMemo();
  }

  @override
  Widget build(BuildContext context) {
    final memoViewModel = ref.watch(memoViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'メモの一覧',
          style: TextStyle(color: Color(0xFF725B51)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 1,
        iconTheme: const IconThemeData(
          color: Color(0xFF725B51),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: memoViewModel.memoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(memoViewModel.memoList[index].memo),
                      subtitle: Text(DateFormat.MMMEd('ja').format(memoViewModel.memoList[index].date)),
                      trailing: IconButton(
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(memoViewModel.roomCode)
                                .collection('memo')
                                .doc(memoViewModel.memoList[index].id)
                                .delete();
                            memoViewModel.fetchMemo();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('メモを削除しました'),
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
                        icon: const Icon(Icons.delete, color: Colors.red,),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () {
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
    );
  }
}
