import 'package:flutter/material.dart';

class RoomMemberList extends StatelessWidget {
  final String imgURL;
  final String userName;
  final bool owner;

  const RoomMemberList({
    required this.imgURL,
    required this.userName,
    required this.owner,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgURL),
      ),
      title: Text(userName),
      subtitle: (owner == true)
          ? const Text('owner')
          : const Text(''),
    );
  }
}
