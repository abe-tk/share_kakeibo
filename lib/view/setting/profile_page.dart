import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_kakeibo/impoter.dart';
import 'dart:io';

class ProfilePage extends StatefulHookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  File? imgFile;

  Future<void> pickImg() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final fileTemp = File(pickedFile.path);
      setState(() => imgFile = fileTemp);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = useState(ref.watch(userProvider)['userName']);
    final userNameController = useState(TextEditingController(text: ref.watch(userProvider)['userName']));
    final imgURL = useState(ref.watch(userProvider)['imgURL']);

    Future<void> updateProfile() async {
      try {
        // ユーザ名に変更があれば更新
        if (userName.value != ref.watch(userProvider)['userName']) {
          await UserFire().updateUserNameFire(userName.value, ref.watch(roomCodeProvider));
          // 過去の収支イベントの支払い元の名前を変更
          await UserFire().updatePastEventUserName(ref.watch(roomCodeProvider), ref.watch(userProvider)['userName'], userName.value);
          // イベントのユーザ名に変更があるため、stateを更新
          await updateUserNameState(ref, DateTime(DateTime.now().year, DateTime.now().month));
        }
        // プロフィール画像に変更があれば更新
        if (imgFile != null) {
          imgURL.value = await StorageFire().putImgFileFire(imgFile!);
          await UserFire().updateUserImgURLFire(imgURL.value, ref.watch(roomCodeProvider));
          updateUserImgURLState(ref);
        }
        Navigator.of(context).pop();
        positiveSnackBar(context, 'プロフィールを編集しました');
      } catch (e) {
        negativeSnackBar(context, e.toString());
      }
    }

    return Scaffold(
      appBar: ActionAppBar(
        title: 'プロフィール',
        icon: Icons.check,
        iconColor: CustomColor.positiveIconColor,
        function: () async => await updateProfile(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SettingTitle(title: 'プロフィール画像'),
            SetProfileImage(
              function: () async => pickImg(),
              imgFile: imgFile,
              imgURL: imgURL.value,
            ),
            const Divider(),
            const SettingTitle(title: 'ユーザ名'),
            SettingTextField(
              controller: userNameController.value,
              suffix: false,
              obscure: false,
              text: 'ユーザ名を入力してください',
              obscureChange: () {},
              textChange: (text) => userName.value = text,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
