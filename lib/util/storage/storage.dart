import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// FireStorageのメンバ関数
class Storage {

  // fireStorageにimgFileを追加（「Userのプロフィール画像を更新」のため）
  Future<String> createImgFile(File imgFile) async {
    final task = await FirebaseStorage.instance.ref('users/${FirebaseFirestore.instance.collection('users').doc().id}').putFile(imgFile);
    final imgURL = await task.ref.getDownloadURL();
    return imgURL;
  }

}