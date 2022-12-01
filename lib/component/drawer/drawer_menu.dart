import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/impoter.dart';

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
                  decoration: const BoxDecoration(
                    color: CustomColor.drawerHeaderColor,
                  ),
                  child: ListView(
                    children: [
                      const Text('ACCOUNT'),
                      const Divider(),
                      ListTile(
                        leading: CircleAvatar(foregroundImage: NetworkImage(userState['imgURL'])),
                        title: Text(userState['userName']),
                        subtitle: Text(userState['email']),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: const Text('ROOM'),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.meeting_room),
                  title: Text(roomNameState),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerLeft,
                  child: const Text('MEMBER'),
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
                        subtitle: (roomMemberState[index].owner == true)
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