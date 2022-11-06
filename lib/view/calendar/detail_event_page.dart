// constant
import 'package:share_kakeibo/constant/number_format.dart';
import 'package:share_kakeibo/constant/colors.dart';
// view
import 'package:share_kakeibo/view/event/edit_event_page.dart';
// view_model
import 'package:share_kakeibo/view_model/calendar/detail_event_view_model.dart';
import 'package:share_kakeibo/view_model/event/edit_event_view_model.dart';
// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/intl.dart';

class DetailEventPage extends StatefulHookConsumerWidget {
  const DetailEventPage({Key? key}) : super(key: key);

  @override
  _DetailEventPageState createState() => _DetailEventPageState();
}

class _DetailEventPageState extends ConsumerState<DetailEventPage> {
  @override
  void initState() {
    super.initState();
    // ref.read(detailEventViewModelProvider.notifier).fetchDetailEvent();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // エラーの出ていた処理
      ref.read(detailEventViewModelProvider.notifier).fetchDetailEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailEventState = ref.watch(detailEventViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('過去の明細'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: appBarBackGroundColor,
        bottom: PreferredSize(
          child: Container(
            height: 0.1,
            color: appBarBottomLineColor,
          ),
          preferredSize: const Size.fromHeight(0.1),
        ),
      ),
      body: SafeArea(
        child: (detailEventState.isNotEmpty)
            ? ListView.builder(
                itemCount: detailEventState.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: listBorderSideColor,
                        ),
                      ),
                    ),
                    child: ListTile(
                      leading: (detailEventState[index].smallCategory == '未分類') ? Icon(Icons.question_mark, color: Colors.grey, size: 30)
                          : (detailEventState[index].smallCategory == '給与') ? Icon(Icons.account_balance_wallet, color: Color(0xFFffd700), size: 30)
                          : (detailEventState[index].smallCategory == '賞与') ? Icon(Icons.payments, color: Color(0xFFff8c00), size: 30)
                          : (detailEventState[index].smallCategory == '臨時収入') ? Icon(Icons.currency_yen, color: Color(0xFFff6347), size: 30)
                          : (detailEventState[index].smallCategory == '食費') ? Icon(Icons.rice_bowl, color: Color(0xFFffe4b5), size: 30)
                          : (detailEventState[index].smallCategory == '外食費') ? Icon(Icons.restaurant, color: Color(0xFFfa8072), size: 30)
                          : (detailEventState[index].smallCategory == '日用雑貨費') ? Icon(Icons.shopping_cart, color: Color(0xFFdeb887), size: 30)
                          : (detailEventState[index].smallCategory == '交通・車両費') ? Icon(Icons.directions_car_outlined, color: Color(0xFFb22222), size: 30)
                          : (detailEventState[index].smallCategory == '住居費') ? Icon(Icons.house, color: Color(0xFFf4a460), size: 30)
                          : (detailEventState[index].smallCategory == '光熱費(電気)') ? Icon(Icons.bolt, color: Color(0xFFf0e68c), size: 30)
                          : (detailEventState[index].smallCategory == '光熱費(ガス)') ? Icon(Icons.local_fire_department, color: Color(0xFFdc143c), size: 30)
                          : (detailEventState[index].smallCategory == '水道費') ? Icon(Icons.water_drop, color: Color(0xFF00bfff), size: 30)
                          : (detailEventState[index].smallCategory == '通信費') ? Icon(Icons.speaker_phone, color: Color(0xFFff00ff), size: 30)
                          : (detailEventState[index].smallCategory == 'レジャー費') ? Icon(Icons.music_note, color: Color(0xFF3cb371), size: 30)
                          : (detailEventState[index].smallCategory == '教育費') ? Icon(Icons.school, color: Color(0xFF9370db), size: 30)
                          : (detailEventState[index].smallCategory == '医療費') ? Icon(Icons.local_hospital_outlined, color: Color(0xFFff7f50), size: 30)
                          : (detailEventState[index].smallCategory == 'ファッション費') ? Icon(Icons.checkroom, color: Color(0xFFffc0cb), size: 30)
                          : Icon(Icons.spa, color: Color(0xFFee82ee), size: 30), // 美容費
                      title: Text(detailEventState[index].smallCategory),
                      subtitle: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: detailIconColor,
                              ),
                              Text('：${detailEventState[index].paymentUser}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 16,
                                color: detailIconColor,
                              ),
                              Text('：${detailEventState[index].memo}'),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: detailIconColor,
                              ),
                              Text('：${DateFormat.MMMEd('ja').format(detailEventState[index].date)}'),
                            ],
                          ),
                        ],
                      ),
                      trailing: Text(
                          (detailEventState[index].largeCategory == '収入')
                          ? '${formatter.format(int.parse(detailEventState[index].price))} 円'
                          : '- ${formatter.format(int.parse(detailEventState[index].price))} 円',
                        style: TextStyle(
                          color: (detailEventState[index].largeCategory == '収入')
                              ? incomeTextColor
                              : spendingTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () async {
                        await ref.read(editEventViewModelProvider.notifier).fetchPaymentUser(detailEventState[index]);
                        Navigator.push(
                          context,
                          PageTransition(
                            child: EditEventPage(detailEventState[index]),
                            type: PageTransitionType.rightToLeft,
                            duration: const Duration(milliseconds: 150),
                            reverseDuration:
                            const Duration(milliseconds: 150),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
            : Column(
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 100,
                    child: Image.asset('assets/image/app_theme_gray.png'),
                  ),
                  const Text('取引が存在しません', style: TextStyle(fontWeight: FontWeight.bold,)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('「', style: TextStyle(color: detailTextColor),),
                      Icon(Icons.edit, size: 16,color: detailTextColor,),
                      Text('入力」から取引を追加してください', style: TextStyle(color: detailTextColor),),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
