// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/room/room_name_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RoomNamePage extends StatefulHookConsumerWidget {
  const RoomNamePage({Key? key}) : super(key: key);

  @override
  _RoomNamePageState createState() => _RoomNamePageState();
}

class _RoomNamePageState extends ConsumerState<RoomNamePage> {

  @override
  void initState() {
    super.initState();
    ref.read(roomNameProvider.notifier).fetchRoomName();
  }

  @override
  Widget build(BuildContext context) {
    final roomNameNotifier = ref.watch(roomNameProvider.notifier);
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
                await roomNameNotifier.changeRoomName();
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
                  controller: roomNameNotifier.roomNameController,
                  decoration: const InputDecoration(
                    hintText: 'Room名を入力してください',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    roomNameNotifier.setRoomName(text);
                  },
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