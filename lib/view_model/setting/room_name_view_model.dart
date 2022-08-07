/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final roomNameViewModel = ChangeNotifierProvider((ref) => RoomNameViewModel());

class RoomNameViewModel extends ChangeNotifier {
  String? roomName;
  String? roomCode;

  TextEditingController roomNameController = TextEditingController();

  void setRoomName(String roomName) {
    this.roomName = roomName;
    notifyListeners();
  }

  Future<void> update() async {
    if (roomName == null || roomName == "") {
      throw 'Room名が入力されていません';
    }

    roomName = roomNameController.text;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .update({
      'roomName': roomName,
    });

  }

  Future<void> fetchRoomName() async {
    final roomCodeSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final roomCodeData = roomCodeSnapshot.data();
    roomCode = roomCodeData?['roomCode'];

    final snapshot =
    await FirebaseFirestore.instance.collection('users').doc(roomCode).get();
    final data = snapshot.data();
    roomName = data?['roomName'];
    roomCode = data?['roomCode'];
    roomNameController.text = roomName!;
    notifyListeners();
  }

}
