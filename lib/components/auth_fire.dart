import 'package:firebase_auth/firebase_auth.dart';

var uid = FirebaseAuth.instance.currentUser!.uid;
var loginState = true;

void changeUid() {
  uid = FirebaseAuth.instance.currentUser!.uid;
}

void registered(value) {
  loginState = value;
}
