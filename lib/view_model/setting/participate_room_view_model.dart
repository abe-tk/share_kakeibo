/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final participateRoomViewModel =
    ChangeNotifierProvider((ref) => ParticipateRoomViewModel());

class ParticipateRoomViewModel extends ChangeNotifier {
  String? roomCode;
  String? roomName;

  String? ownerRoomCode;

  String? userName;
  String? imgURL;

  TextEditingController roomCodeController = TextEditingController();

  void setRoomCode(String roomCode) {
    this.roomCode = roomCode;
    notifyListeners();
  }

  void clearRoomCode() {
    roomCode = null;
    roomCodeController.clear();
    notifyListeners();
  }

  Future<void> joinRoom() async {
    roomCode = roomCodeController.text;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .get();
    final data = snapshot.data();
    ownerRoomCode = data?['roomCode'];
    roomName = data?['roomName'];

    if (roomCode == null || roomCode == "") {
      throw '招待コードが入力されていません';
    } else if (roomCode != ownerRoomCode ||
        ownerRoomCode == null ||
        ownerRoomCode == '') {
      throw '招待コードが正しくありません';
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'roomCode': roomCode,
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('room')
        .doc(uid)
        .set({
      'imgURL': imgURL,
      'owner': false,
      'userName': userName,
    });

    notifyListeners();
  }

  Future<void> fetchUser() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    imgURL = data?['imgURL'];
    userName = data?['userName'];
    notifyListeners();
  }
}
