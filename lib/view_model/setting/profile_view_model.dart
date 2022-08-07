/// components
import 'package:share_kakeibo/components/auth_fire.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

final profileViewModel = ChangeNotifierProvider((ref) => ProfileViewModel());

class ProfileViewModel extends ChangeNotifier {
  String? oldName;
  String? name;
  String? imgURL;
  String? newImgURL;
  File? imgFile;
  String? roomCode;

  TextEditingController nameController = TextEditingController();

  final picker = ImagePicker();

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setNewImgURL(String imgFile) {
    newImgURL = imgFile;
    notifyListeners();
  }

  Future<void> pickImg() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imgFile = File(pickedFile.path);
    }
    notifyListeners();
  }

  void clearImgFile() {
    imgFile = null;
    notifyListeners();
  }

  Future<void> update() async {
    if (name == null || name == "") {
      throw 'ユーザ名が入力されていません';
    }

    name = nameController.text;

    final doc = FirebaseFirestore.instance.collection('users').doc();

    if (imgFile != null) {
      final task = await FirebaseStorage.instance
          .ref('users/${doc.id}')
          .putFile(imgFile!);
      final newImgURL = await task.ref.getDownloadURL();
      this.newImgURL = newImgURL;
    }

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'userName': name,
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(roomCode)
        .collection('room')
        .doc(uid)
        .update({
      'userName': name,
    });

    if (newImgURL != null) {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'imgURL': newImgURL,
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(roomCode)
          .collection('room')
          .doc(uid)
          .update({
        'imgURL': newImgURL,
      });
    }

    FirebaseFirestore.instance.collection('users').doc(roomCode).collection('events').where('paymentUser', isEqualTo: oldName).get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {

        FirebaseFirestore.instance
            .collection('users')
            .doc(roomCode)
            .collection('events')
            .doc(doc.id)
            .update({
          'paymentUser': name,
        });

      }
    });

  }

  Future<void> fetchProfile() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = snapshot.data();
    imgURL = data?['imgURL'];
    name = data?['userName'];
    oldName = data?['userName'];
    roomCode = data?['roomCode'];

    nameController.text = name!;
    notifyListeners();
  }

}
