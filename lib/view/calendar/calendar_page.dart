import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'dart:collection';
import 'package:share_kakeibo/impoter.dart';

class CalendarPage extends StatefulHookConsumerWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDay = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toUtc().add(const Duration(hours: 9));

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    // ref.read(calendarViewModelProvider.notifier).fetchCalendarEvent();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      // エラーの出ていた処理
      ref.read(calendarViewModelProvider.notifier).fetchCalendarEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarEventState = ref.watch(calendarViewModelProvider);

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )
      ..addAll(calendarEventState);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/detailEventPage');
            },
            icon: const Icon(Icons.receipt_long),
          ),
        ],
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
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.7,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              // color: Colors.white,
              child: TableCalendar(
                shouldFillViewport: true,
                locale: 'ja_JP',
                firstDay: DateTime(2000),
                lastDay: DateTime(2050),
                focusedDay: _focusedDay,
                eventLoader: _getEventForDay,
                // イベント数のアイコン
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return _buildEventsMarker(date, events);
                    }
                    return null;
                  },
                ),
                //Day Changed
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    _getEventForDay(selectedDay);
                  }
                },
                // Header Style
                headerStyle: HeaderStyle(
                  leftChevronIcon: Icon(
                    Icons.keyboard_arrow_left,
                    color: detailIconColor,
                  ),
                  rightChevronIcon: Icon(
                    Icons.keyboard_arrow_right,
                    color: detailIconColor,
                  ),
                  titleCentered: true,
                  formatButtonVisible: false,
                ),
                // 曜日の高さ
                daysOfWeekHeight: 20,
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                  bottom: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              child: Text(
                DateFormat.MMMEd('ja').format(_selectedDay),
              ),
            ),

            Visibility(
              visible: ref.read(calendarViewModelProvider.notifier).checkExistenceEvent(_selectedDay),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 100,
                    child: Image.asset('assets/image/app_theme_gray.png'),
                  ),
                  const Text('取引が存在しません', style: TextStyle(fontWeight: FontWeight.bold,),
                  ),
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

            Expanded(
              child: ListView(
                children: _getEventForDay(_selectedDay)
                    .map(
                      (event) =>
                      Column(
                        children: [
                          Container(
                            height: 80,
                            alignment: Alignment.center,
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              child: Stack(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    height: 80,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.withOpacity(0.2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 16),
                                        (event.smallCategory == '未分類') ? Icon(Icons.question_mark, color: Colors.grey, size: 30)
                                            : (event.smallCategory == '給与') ? Icon(Icons.account_balance_wallet, color: Color(0xFFffd700), size: 30)
                                            : (event.smallCategory == '賞与') ? Icon(Icons.payments, color: Color(0xFFff8c00), size: 30)
                                            : (event.smallCategory == '臨時収入') ? Icon(Icons.currency_yen, color: Color(0xFFff6347), size: 30)
                                            : (event.smallCategory == '食費') ? Icon(Icons.rice_bowl, color: Color(0xFFffe4b5), size: 30)
                                            : (event.smallCategory == '外食費') ? Icon(Icons.restaurant, color: Color(0xFFfa8072), size: 30)
                                            : (event.smallCategory == '日用雑貨費') ? Icon(Icons.shopping_cart, color: Color(0xFFdeb887), size: 30)
                                            : (event.smallCategory == '交通・車両費') ? Icon(Icons.directions_car_outlined, color: Color(0xFFb22222), size: 30)
                                            : (event.smallCategory == '住居費') ? Icon(Icons.house, color: Color(0xFFf4a460), size: 30)
                                            : (event.smallCategory == '光熱費(電気)') ? Icon(Icons.bolt, color: Color(0xFFf0e68c), size: 30)
                                            : (event.smallCategory == '光熱費(ガス)') ? Icon(Icons.local_fire_department, color: Color(0xFFdc143c), size: 30)
                                            : (event.smallCategory == '水道費') ? Icon(Icons.water_drop, color: Color(0xFF00bfff), size: 30)
                                            : (event.smallCategory == '通信費') ? Icon(Icons.speaker_phone, color: Color(0xFFff00ff), size: 30)
                                            : (event.smallCategory == 'レジャー費') ? Icon(Icons.music_note, color: Color(0xFF3cb371), size: 30)
                                            : (event.smallCategory == '教育費') ? Icon(Icons.school, color: Color(0xFF9370db), size: 30)
                                            : (event.smallCategory == '医療費') ? Icon(Icons.local_hospital_outlined, color: Color(0xFFff7f50), size: 30)
                                            : (event.smallCategory == 'ファッション費') ? Icon(Icons.checkroom, color: Color(0xFFffc0cb), size: 30)
                                            : Icon(Icons.spa, color: Color(0xFFee82ee), size: 30), // 美容費
                                        const SizedBox(width: 16),
                                        SizedBox(
                                          height: 80,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event.smallCategory,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.person,
                                                    size: 16,
                                                    color: detailIconColor,
                                                  ),
                                                  Text('：${event.paymentUser}',
                                                    style: TextStyle(
                                                        color: detailTextColor),),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    size: 16,
                                                    color: detailIconColor,
                                                  ),
                                                  Text('：${event.memo ?? ''}',
                                                    style: TextStyle(
                                                        color: detailTextColor),),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // margin: EdgeInsets.all(0),
                                    alignment: Alignment.centerRight,
                                    height: 80,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 16.0),
                                      child: Text(
                                        (event.largeCategory == '収入')
                                            ? '${formatter.format(
                                            int.parse(event.price))} 円'
                                            : '- ${formatter.format(
                                            int.parse(event.price))} 円',
                                        style: TextStyle(
                                            color: (event.largeCategory == '収入')
                                                ? incomeTextColor
                                                : spendingTextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () async {
                                await ref.read(editEventViewModelProvider.notifier).fetchPaymentUser(event);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: EditEventPage(event),
                                    type: PageTransitionType.rightToLeft,
                                    duration: const Duration(milliseconds: 150),
                                    reverseDuration:
                                    const Duration(milliseconds: 150),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildEventsMarker(DateTime date, List events) {
  return Positioned(
    right: 5,
    bottom: 5,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: batchBackGroundColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: batchTextColor,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}
