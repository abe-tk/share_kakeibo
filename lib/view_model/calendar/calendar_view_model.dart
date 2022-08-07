/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// model
import 'package:share_kakeibo/model/event.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calendarViewModelProvider = ChangeNotifierProvider((ref) => CalendarViewModel());

class CalendarViewModel extends ChangeNotifier {

  late String roomCode;
  List<Event> eventList = [];
  Map<DateTime, List<Event>> eventMap = {};

  Future <void> fetchRoomCode() async {
    final codeSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = codeSnapshot.data();
    roomCode = data?['roomCode'];
  }

  Future <void> fetchEvent() async {

    eventMap = {};

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('events')
        .get();

    final events =
    snapshot.docs.map((snapshot) => Event(snapshot)).toList();
    eventList = events;

    for (final document in snapshot.docs) {
      final event = Event(document);
      final value = eventMap[event.date] ?? [];
      eventMap[event.date] = [event, ...value];
    }
    notifyListeners();
  }

}
