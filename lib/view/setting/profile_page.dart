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

  Future<void> updateProfile(String userName, String imgURL) async {
    // ユーザ名が空でなければ更新
    updateUserNameValidation(userName);
    await updateUserNameFire(userName, ref.watch(roomCodeProvider));
    // 過去の収支イベントの支払い元の名前を変更
    await updatePastEventUserName(ref.watch(roomCodeProvider), ref.watch(userProvider)['userName'], userName);
    // プロフィール画像に変更があれば更新
    if (imgFile != null) {
      imgURL = await putImgFileFire(imgFile!);
      await updateUserImgURLFire(imgURL, ref.watch(roomCodeProvider));
    }
  }

  void updateState() {
    // 統計の円グラフを更新
    ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider));
    ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider), ref.read(roomMemberProvider));
    ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider));
    ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month), ref.read(eventProvider), ref.read(roomMemberProvider));
    // カレンダーのイベントを更新
    ref.read(eventProvider.notifier).setEvent();
    // user情報の再取得
    ref.read(userProvider.notifier).fetchUser();
    // roomMemberの情報を更新
    ref.read(roomMemberProvider.notifier).fetchRoomMember();
  }

  @override
  Widget build(BuildContext context) {
    final userName = useState(ref.watch(userProvider)['userName']);
    final userNameController = useState(TextEditingController(text: ref.watch(userProvider)['userName']));
    final imgURL = useState(ref.watch(userProvider)['imgURL']);
    return Scaffold(
      appBar: ActionAppBar(
        title: 'プロフィール',
        icon: Icons.check,
        iconColor: CustomColor.positiveIconColor,
        function: () async {
          try {
            await updateProfile(userName.value, imgURL.value);
            updateState();
            Navigator.of(context).pop();
            positiveSnackBar(context, 'プロフィールを編集しました');
          } catch (e) {
            negativeSnackBar(context, e.toString());
          }
        },
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
          ],
        ),
      ),
    );
  }
}
