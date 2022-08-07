/// view_model
import 'package:share_kakeibo/view_model/setting/room_name_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/view_model/setting/room_info_view_model.dart';

class RoomNamePage extends StatefulHookConsumerWidget {
  const RoomNamePage({Key? key}) : super(key: key);

  @override
  _RoomNamePageState createState() => _RoomNamePageState();
}

class _RoomNamePageState extends ConsumerState<RoomNamePage> {
  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(roomNameViewModel).fetchRoomName();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(roomNameViewModel);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Roomの名前を編集',
          style: TextStyle(color: Color(0xFF725B51)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFFCF6EC),
        elevation: 1,
        iconTheme: const IconThemeData(color: Color(0xFF725B51)),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await model.update();
                ref.read(roomInfoViewModel).fetchRoom();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('Room名を変更しました'),
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
            icon: const Icon(
              Icons.check,
              color: Colors.green,
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
              child: const Text(
                'Room名',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Divider(),
            Container(
              color: Colors.white,
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                title:TextField(
                  textAlign: TextAlign.left,
                  controller: model.roomNameController,
                  decoration: const InputDecoration(
                    hintText: 'Room名を入力してください',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    model.setRoomName(text);
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