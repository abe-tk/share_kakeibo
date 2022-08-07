/// packages
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomMember {
  RoomMember(DocumentSnapshot doc) {
    userName = doc['userName'];
    imgURL = doc['imgURL'];
    owner = doc['owner'];
  }
  late String userName;
  late String imgURL;
  late bool owner;
}
