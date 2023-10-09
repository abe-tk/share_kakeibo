import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/common_widget/dialog/input_text_dialog.dart';
import 'package:share_kakeibo/feature/memo/application/memo_service.dart';
import 'package:share_kakeibo/importer.dart';

class CustomFab extends HookConsumerWidget {
  final Function selectIndex;
  const CustomFab({
    Key? key,
    required this.selectIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memo = useState('');
    final memoController = useTextEditingController();
    final roomMember = ref.watch(roomMemberProvider).whenOrNull(
          data: (data) => data,
        );

    final roomCode =
        ref.watch(roomCodeProvider).whenOrNull(
              data: (data) => data,
            );

    return FloatingActionButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(90),
      ),
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
                    padding: EdgeInsets.only(
                        top: 10, left: 60, right: 60, bottom: 10),
                    child: Divider(thickness: 3),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add),
                          title: const Text('収入の追加'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await ref
                                .read(paymentUserProvider.notifier)
                                .fetchPaymentUser(roomMember!);
                            Navigator.pushNamed(context, '/addIncomeEventPage');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.remove),
                          title: const Text('支出の追加'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await ref
                                .read(paymentUserProvider.notifier)
                                .fetchPaymentUser(roomMember!);
                            Navigator.pushNamed(
                                context, '/addSpendingEventPage');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('メモの追加'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            try {
                              selectIndex();
                              Navigator.of(context).pop();
                              memo.value = await InputTextDialog.show(
                                    context: context,
                                    title: 'メモを追加',
                                    hintText: 'メモ',
                                    confirmButtonText: '追加',
                                  ) ??
                                  '';
                              if (memo.value.isNotEmpty) {
                                await ref.read(memoService).createMemo(
                                      roomCode: roomCode!,
                                      memo: memo.value,
                                    );
                                memoController.clear();
                                memo.value = '';
                              }
                              // positiveSnackBar(context, 'メモを追加しました！');
                            } catch (e) {
                              negativeSnackBar(context, e.toString());
                            }
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
