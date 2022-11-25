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
      imgURL = await putImgFileFire(imgFile);
      await updateUserImgURLFire(imgURL, ref.watch(roomCodeProvider));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userName = useState(ref.watch(userProvider)['userName']);
    final userNameController = useState(TextEditingController(text: ref.watch(userProvider)['userName']));
    final imgURL = useState(ref.watch(userProvider)['imgURL']);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'プロフィール',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          AppIconButton(
            icon: Icons.check,
            color: positiveIconColor,
            function: () async {
              try {
                await updateProfile(userName.value, imgURL.value);
                // 統計の円グラフを更新
                ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc(DateTime(DateTime.now().year, DateTime.now().month));
                // カレンダーのイベントを更新
                ref.read(eventProvider.notifier).setEvent();
                // user情報の再取得
                ref.read(userProvider.notifier).fetchUser();
                // roomMemberの情報を更新
                ref.read(roomMemberProvider.notifier).fetchRoomMember();
                Navigator.of(context).pop();
                positiveSnackBar(context, 'プロフィールを編集しました');
              } catch (e) {
                negativeSnackBar(context, e.toString());
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Text(
                'プロフィール画像',
                style: TextStyle(color: detailTextColor),
              ),
            ),
            const Divider(),
            GestureDetector(
              child: SizedBox(
                width: 150,
                height: 150,
                child: imgFile == null
                    ? Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(65, 65, 65, 0.1),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(imgURL.value ?? 'https://kotonohaworks.com/free-icons/wp-content/uploads/kkrn_icon_user_11.png',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(65, 65, 65, 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.file(
                          imgFile!,
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              onTap: () async => pickImg(),
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              child: Text(
                'ユーザ名',
                style: TextStyle(color: detailTextColor),
              ),
            ),
            const Divider(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListTile(
                title: TextField(
                  textAlign: TextAlign.left,
                  controller: userNameController.value,
                  decoration: const InputDecoration(
                    hintText: 'ユーザ名を入力してください',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) => userName.value = text,
                ),
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
