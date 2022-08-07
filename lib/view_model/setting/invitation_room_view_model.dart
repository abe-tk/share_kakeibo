/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final invitationRoomViewModel =
    ChangeNotifierProvider((ref) => InvitationRoomViewModel());

class InvitationRoomViewModel extends ChangeNotifier {
  String? roomCode;

  Future<void> fetchRoomCode() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    roomCode = data?['roomCode'];
    notifyListeners();
  }
}
