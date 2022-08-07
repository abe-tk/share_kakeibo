/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// model
import 'package:share_kakeibo/model/room_member.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomInfoViewModel = ChangeNotifierProvider((ref) => RoomInfoViewModel());

class RoomInfoViewModel extends ChangeNotifier {
  String? roomCode;
  String? roomName;

  String? name;
  String? imgURL;
  String? email;

  List<RoomMember> roomMemberList = [];

  Future<void> fetchRoom() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    roomCode = data?['roomCode'];

    final roomNameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .get();
    final roomNameData = roomNameSnapshot.data();
    roomName = roomNameData?['roomName'];

    final roomMemberSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('room')
        .get();

    final roomMembers = roomMemberSnapshot.docs
        .map((snapshot) => RoomMember(snapshot))
        .toList();
    roomMemberList = roomMembers;

    final userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final userData = userSnapshot.data();
    imgURL = userData?['imgURL'];
    email = userData?['email'];
    name = userData?['userName'];

    notifyListeners();
  }

  void judgeOwner() {
    if (uid == roomCode) {
      throw 'RoomOwnerは退出できません';
    }
  }

  Future <void> exitRoom() async {

    FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').where('paymentUser', isEqualTo: name).get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(roomCode)
            .collection('events')
            .doc(doc.id)
            .delete();

      }
    });

    FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('room')
        .doc(uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({
      'roomCode': uid,
    });

  }

}
