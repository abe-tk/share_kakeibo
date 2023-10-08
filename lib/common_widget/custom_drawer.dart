import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';

class CustomDrawer extends ConsumerWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ルーム名
    final roomNameState = ref.watch(roomNameProvider);

    // ルームメンバー
    final roomMemberState = ref.watch(roomMemberProvider);
    
    return Drawer(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ルーム名
                  const SizedBox(height: 60),
                  const SubTitle(title: 'ROOM'),
                  roomNameState.when(
                    loading: () => const CircularProgressIndicator(),
                    error: (error, stack) => const Text('error'),
                    data: (data) => CustomListTile(
                      title: data,
                      leading: const Icon(Icons.meeting_room),
                      isTrailing: false,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ルームメンバー
                  const SubTitle(title: 'MEMBER'),
                  // メンバーリストのみスクロール可能にしている
                  MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    child: roomMemberState.when(
                      loading: () => const CircularProgressIndicator(),
                      error: (error, stack) => const Text('error'),
                      data: (data) => ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: CircleAvatar(
                              foregroundImage: NetworkImage(data[index].imgURL),
                            ),
                            title: Text(data[index].userName),
                            subtitle: (data[index].owner == true)
                                ? const Text('owner')
                                : const SizedBox.shrink(),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
