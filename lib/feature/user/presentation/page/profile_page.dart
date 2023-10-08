import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_kakeibo/common_widget/custom_text_field.dart';
import 'package:share_kakeibo/importer.dart';
import 'dart:io';

import 'package:share_kakeibo/util/storage/storage.dart';

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

    final roomCode = ref.watch(roomCodeProvider(ref.watch(uidProvider))).whenOrNull(
          data: (data) => data,
        );

    Future<void> pickImg() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imgFilePath.value = pickedFile.path;
      }
    }

    Future<void> updateProfile() async {
      try {
        // プロフィール画像に変更があれば更新
        if (imgFilePath.value != '') {
          imgURL.value = await Storage().createImgFile(File(imgFilePath.value));
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
        // ユーザ名に変更があれば更新、イベント関連のstateを更新
        if (userName.value != beforeUserData!.userName) {
          // ref.read(eventProvider.notifier).setEvent();
          ref
              .read(roomMemberProvider.notifier)
              .readRoomMember(roomCode: roomCode);
        }
        Navigator.of(context).pop();
        positiveSnackBar(context, 'プロフィールを編集しました');
      } catch (e) {
        negativeSnackBar(context, e.toString());
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
