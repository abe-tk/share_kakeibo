// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/user/user_state.dart';
import 'package:share_kakeibo/state/room/room_member_state.dart';
import 'package:share_kakeibo/state/room/room_name_state.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DrawerMenu extends StatefulHookConsumerWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends ConsumerState<DrawerMenu> {

  @override
  Widget build(BuildContext context) {
    final roomMemberState = ref.watch(roomMemberProvider);
    final roomNameState = ref.watch(roomNameProvider);
    final userState = ref.watch(userProvider);
    return Drawer(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: drawerHeaderColor,
                  ),
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          'マイアカウント',
                          style: TextStyle(
                            // color: Colors.white,
                          ),
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(userState['imgURL']),
                        ),
                        title: Text(
                          userState['userName'] ?? '',
                          style: const TextStyle(
                            // color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          userState['email'] ?? '',
                          style: const TextStyle(
                            // color: Colors.white,
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
                      // color: Color(0xFFEBEBEB),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: Icon(
                    Icons.meeting_room,
                    color: roomNameIconColor,
                  ),
                  title: Text(roomNameState),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  child: const Text(
                    'MEMBER',
                    style: TextStyle(
                      // color: Color(0xFFEBEBEB),
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
                    itemCount: roomMemberState.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        leading: CircleAvatar(
                          foregroundImage: NetworkImage(roomMemberState[index].imgURL),
                        ),
                        title: Text(roomMemberState[index].userName),
                        subtitle:
                        (roomMemberState[index].owner == true)
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
        ],
      ),
    );
  }
}