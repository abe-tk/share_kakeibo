import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_kakeibo/impoter.dart';

class RoomNamePage extends HookConsumerWidget {
  const RoomNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomNameNotifier = ref.watch(roomNameProvider.notifier);
    final roomName = useState(ref.watch(roomNameProvider));
    final roomNameController = useState(TextEditingController(text: ref.watch(roomNameProvider)));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Roomの名前を編集',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await roomNameNotifier.changeRoomName(roomName.value);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: positiveSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: const Text('Room名を変更しました'),
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
            icon: Icon(
              Icons.check,
              color: positiveIconColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Room名',
                style: TextStyle(color: detailTextColor),
              ),
            ),
            const Divider(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                title:TextField(
                  textAlign: TextAlign.left,
                  controller: roomNameController.value,
                  decoration: const InputDecoration(
                    hintText: 'Room名を入力してください',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) => roomName.value = text,
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}