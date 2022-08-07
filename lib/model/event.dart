/// packages
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  late String id;
  late DateTime date;
  late String price;
  late String largeCategory;
  late String smallCategory;
  late String memo;
  late String paymentUser;
  Event(DocumentSnapshot doc) {
    id = doc.id;
    date = (doc['date'] as Timestamp).toDate();
    price = doc['price'];
    largeCategory = doc['largeCategory'];
    smallCategory = doc['smallCategory'];
    memo = doc['memo'];
    paymentUser = doc['paymentUser'];
  }
}
