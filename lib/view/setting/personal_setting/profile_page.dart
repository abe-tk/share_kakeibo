// constant
import 'package:share_kakeibo/constant/colors.dart';
// state
import 'package:share_kakeibo/state/user/user_state.dart';
import 'package:share_kakeibo/state/room/room_member_state.dart';
import 'package:share_kakeibo/state/event/calendar_event_state.dart';
import 'package:share_kakeibo/state/pie_chart/income_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_category_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/income_user_pie_chart_state.dart';
import 'package:share_kakeibo/state/pie_chart/spending_user_pie_chart_state.dart';
// view_model
import 'package:share_kakeibo/view_model/setting/personal_setting/profile_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfilePage extends StatefulHookConsumerWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  @override
  void initState() {
    super.initState();
    ref.read(profileViewModelProvider.notifier).fetchProfile();
    // Future(() async {
    //   await ref.read(profileViewModelProvider.notifier).fetchProfile();
    // });
  }

  @override
  Widget build(BuildContext context) {
    final profileViewModelState = ref.watch(profileViewModelProvider);
    final profileViewModelNotifier = ref.watch(profileViewModelProvider.notifier);
    final isImgFileChanged = useState(true);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'プロフィール',
        ),
        centerTitle: true,
        backgroundColor: appBarBackGroundColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await profileViewModelNotifier.updateProfile();
                // 統計の円グラフを更新
                ref.read(incomeCategoryPieChartStateProvider.notifier).incomeCategoryChartCalc();
                ref.read(incomeUserPieChartStateProvider.notifier).incomeUserChartCalc();
                ref.read(spendingCategoryPieChartStateProvider.notifier).spendingCategoryChartCalc();
                ref.read(spendingUserPieChartStateProvider.notifier).spendingUserChartCalc();
                // カレンダーのイベントを更新
                ref.read(calendarEventProvider.notifier).fetchCalendarEvent();
                // user情報の再取得
                ref.read(userProvider.notifier).fetchUser();
                // roomMemberの情報を更新
                ref.read(roomMemberProvider.notifier).fetchRoomMember();

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: positiveSnackBarColor,
                    behavior: SnackBarBehavior.floating,
                    content: const Text('プロフィールを編集しました'),
                  ),
                );
              } catch (e) {
                final snackBar = SnackBar(
                  backgroundColor: negativeSnackBarColor,
                  behavior: SnackBarBehavior.floating,
                  content: Text(e.toString()),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(
              Icons.check,
              color: positiveIconColor,
            ),
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
                child: (profileViewModelState['imgFile'] == null)
                    ? Container(
                        width: 150,
                        height: 150,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(65, 65, 65, 0.1),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(profileViewModelState['imgURL'] ??
                                'https://kotonohaworks.com/free-icons/wp-content/uploads/kkrn_icon_user_11.png',
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
                          profileViewModelState['imgFile'],
                          fit: BoxFit.cover,
                        ),
                      ),
              ),
              onTap: () async {
                await profileViewModelNotifier.pickImg();
                /// useStateの値を変更しないとimgFileが更新されないため、一時的な対応
                isImgFileChanged.value = !isImgFileChanged.value;
              },
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
                  controller: profileViewModelNotifier.nameController,
                  decoration: const InputDecoration(
                    hintText: 'ユーザ名を入力してください',
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    profileViewModelNotifier.setName(text);
                  },
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
