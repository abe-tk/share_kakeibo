import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class Fab extends HookConsumerWidget {
  final Function selectIndex;
  const  Fab({
    Key? key,
    required this.selectIndex,
  }) : super(key: key);

  void showMemoDialog(BuildContext context, WidgetRef ref, String memo, TextEditingController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("メモの追加"),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context),
              child: MemoTextField(
                controller: controller,
                textChange: (text) => memo = text,
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
                      await ref.read(memoProvider.notifier).addMemo(memo);
                      Navigator.of(context).pop();
                      positiveSnackBar(context, 'メモを追加しました！');
                    } catch (e) {
                      negativeSnackBar(context, e.toString());
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
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final memo = useState('');
    final memoController = useState(TextEditingController());
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
                    padding: EdgeInsets.only(top: 10,left: 60, right: 60, bottom: 10),
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
                            await ref.read(paymentUserProvider.notifier).fetchPaymentUser(ref.read(roomMemberProvider));
                            Navigator.pushNamed(context, '/addIncomeEventPage');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.remove),
                          title: const Text('支出の追加'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            await ref.read(paymentUserProvider.notifier).fetchPaymentUser(ref.read(roomMemberProvider));
                            Navigator.pushNamed(context, '/addSpendingEventPage');
                          },
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('メモの追加'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            selectIndex();
                            Navigator.of(context).pop();
                            showMemoDialog(context, ref, memo.value, memoController.value);
                            memoController.value.clear();
                            memo.value = '';
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
