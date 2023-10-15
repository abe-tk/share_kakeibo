import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_kakeibo/common_widget/custom_text_field.dart';
import 'package:share_kakeibo/importer.dart';
import 'dart:io';

class ProfilePage extends HookConsumerWidget {
  const ProfilePage({
    Key? key,
    this.userData,
  }) : super(key: key);

  final UserData? userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // プロフィール画像
    final imgURL = useState(userData!.imgURL);

    // プロフィール画像のファイルパス
    final imgFilePath = useState('');

    // ユーザー名
    final userName = useState(userData!.userName);
    final userNameController =
        useTextEditingController(text: userData!.userName);

    final beforeUserData = ref.watch(userInfoProvider).whenOrNull(
          data: (data) => data,
        );

    final roomCode = ref.watch(roomCodeProvider).whenOrNull(
          data: (data) => data,
        );

    final scaffoldMessenger = ref.watch(scaffoldKeyProvider).currentState!;

    Future<void> pickImg() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imgFilePath.value = pickedFile.path;
      }
    }

    // fireStorageにimgFileを追加（「Userのプロフィール画像を更新」のため）
    Future<String> _createImgFile(File imgFile) async {
      final task = await FirebaseStorage.instance
          .ref(
              'users/${FirebaseFirestore.instance.collection('users').doc().id}')
          .putFile(imgFile);
      final imgURL = await task.ref.getDownloadURL();
      return imgURL;
    }

    Future<void> updateProfile() async {
      try {
        // プロフィール画像に変更があれば更新
        if (imgFilePath.value != '') {
          imgURL.value = await _createImgFile(File(imgFilePath.value));
        }

        // ユーザー名のバリデーション
        final validMessage = Validator.validateUserName(value: userName.value);
        if (validMessage != null) {
          final snackbar = CustomSnackBar(
            context,
            msg: validMessage,
            color: Colors.red,
          );
          scaffoldMessenger.showSnackBar(snackbar);
          return;
        }

        // ユーザー情報の更新
        await ref.read(userInfoProvider.notifier).updateUser(
              uid: ref.watch(uidProvider),
              roomCode: roomCode!,
              userData: userData!,
              userName: userName.value,
              imgURL: imgURL.value,
              imgFilePath: imgFilePath.value,
            );

        // ルームメンバーを更新
        ref.invalidate(roomMemberProvider);

        // ユーザ名に変更があれば更新、イベント関連のstateを更新
        if (userName.value != beforeUserData!.userName) {
          // ref.read(eventProvider.notifier).setEvent();
          ref.invalidate(eventProvider);
          ref
              .read(roomMemberProvider.notifier)
              .readRoomMember(roomCode: roomCode);
        }
        Navigator.of(context).pop();
        final snackbar = CustomSnackBar(
          context,
          msg: 'プロフィールを編集しました',
        );
        scaffoldMessenger.showSnackBar(snackbar);
      } catch (e) {
        logger.e(e.toString());
      }
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'プロフィール'),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SubTitle(title: 'プロフィール画像'),
              SetProfileImage(
                function: () async => pickImg(),
                imgFilePath: imgFilePath.value,
                imgURL: imgURL.value,
              ),
              const SubTitle(title: 'ユーザ名'),
              CustomTextField(
                hintText: 'ユーザ名を入力してください',
                controller: userNameController,
                textChange: (text) => userName.value = text,
              ),
              const SizedBox(height: 16),
              CustomElevatedButton(
                text: '保存',
                onTaped: () async {
                  await updateProfile();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
