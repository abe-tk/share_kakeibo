import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:share_kakeibo/feature/memo/application/memo_service.dart';
import 'package:share_kakeibo/importer.dart';

class MemoPage extends HookConsumerWidget {
  const MemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memoList = ref.watch(memoProvider);

    final roomCode =
        ref.watch(roomCodeProvider(ref.watch(uidProvider))).whenOrNull(
              data: (data) => data,
            );

    // Future<void> removeMemo() async {
    //   try {
    //     await ref.watch(memoService).deleteMemo(roomCode: roomCode!, id: '');
    //     negativeSnackBar(context, 'メモを削除しました');
    //   } catch (e) {
    //     negativeSnackBar(context, e.toString());
    //   }
    // }

    return Scaffold(
      appBar: const CustomAppBar(title: 'メモ'),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: memoList.when(
            loading: () => const CircularProgressIndicator(),
            error: (error, stack) => const Text('error'),
            data: (data) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: data.length + 1,
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return (data.isEmpty)
                      ? const NonDataCase(
                          text: 'メモ',
                          topPadding: 200,
                        )
                      : const SizedBox(height: 50);
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8, right: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0.0, 3.0),
                          blurRadius: 3.0,
                        ),
                      ],
                      color: CustomColor.bdColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: Text(data[index].memo),
                      subtitle: Text(
                        (DateFormat.MMMEd('ja')
                            .format(data[index].registerDate)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
