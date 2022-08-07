import 'package:cloud_firestore/cloud_firestore.dart';

class Memo {
  late String id;
  late String memo;
  late DateTime date;
  Memo(DocumentSnapshot doc) {
    id = doc.id;
    memo = doc['memo'];
    date = (doc['registerDate'] as Timestamp).toDate();
  }
}