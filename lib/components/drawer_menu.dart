/// view
import 'package:share_kakeibo/view/setting/setting_page.dart';

/// view_model
import 'package:share_kakeibo/view_model/setting/room_info_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerMenu extends StatefulHookConsumerWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends ConsumerState<DrawerMenu> {

  @override
  void initState() {
    super.initState();
    ref.read(roomInfoViewModel).fetchRoom();
  }

  @override
  Widget build(BuildContext context) {
    final roomInfoModel = ref.watch(roomInfoViewModel);
    return Drawer(
      backgroundColor: const Color(0xFFFCF6EC),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Color(0xFF725B51),
                  ),
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          'マイアカウント',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(roomInfoModel.imgURL ??
                              'https://kotonohaworks.com/free-icons/wp-content/uploads/kkrn_icon_user_11.png'),
                        ),
                        title: Text(
                          roomInfoModel.name ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          roomInfoModel.email ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    'ROOM',
                    style: TextStyle(
                      color: Color(0xFF725B51),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(
                    Icons.meeting_room,
                    color: Color(0xFF725B51),
                  ),
                  title: Text(roomInfoModel.roomName ?? ''),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    'MEMBER',
                    style: TextStyle(
                      color: Color(0xFF725B51),
                    ),
                  ),
                ),
                const Divider(),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: roomInfoModel.roomMemberList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            roomInfoModel.roomMemberList[index].imgURL,
                          ),
                        ),
                        title: Text(roomInfoModel.roomMemberList[index].userName),
                        subtitle:
                            (roomInfoModel.roomMemberList[index].owner == true)
                                ? const Text('owner')
                                : const Text(''),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                color: const Color(0xFF725B51),
                child: ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: const Text(
                    '設定',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const SettingPage();
                        },
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
