import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      ref.read(calendarViewModelProvider.notifier).fetchCalendarEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarEventState = ref.watch(calendarViewModelProvider);
    final _focusedDay = useState(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    final _selectedDay = useState(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toUtc().add(const Duration(hours: 9)));

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(calendarEventState);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('カレンダー'),
        actions: [
          AppIconButton(
            icon: Icons.receipt_long,
            color: Colors.black,
            function: () => Navigator.pushNamed(context, '/detailEventPage'),
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
              height: MediaQuery.of(context).size.width * 0.7,
              width: MediaQuery.of(context).size.width,
              child: AppTableCalendar(
                focused: _focusedDay.value,
                selected: _selectedDay.value,
                eventLoader: _getEventForDay,
                getEventForDay: _getEventForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  _selectedDay.value = selectedDay;
                  _focusedDay.value = focusedDay;
                },
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
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
                DateFormat.MMMEd('ja').format(_selectedDay.value),
              ),
            ),
            Visibility(
              visible: ref.read(calendarViewModelProvider.notifier).checkExistenceEvent(_selectedDay.value),
              child: const NoDataCase(text: '取引'),
            ),
            Expanded(
              child: ListView(
                children: _getEventForDay(_selectedDay.value)
                    .map(
                      (event) => Column(
                        children: [
                          AppCalendarList(
                            price: event.price,
                            largeCategory: event.largeCategory,
                            smallCategory: event.smallCategory,
                            paymentUser: event.paymentUser,
                            memo: event.memo,
                            function: () {
                              ref.read(paymentUserProvider.notifier).fetchPaymentUser();
                              Navigator.push(
                                context,
                                PageTransition(
                                  child: EditEventPage(event: event),
                                  type: PageTransitionType.rightToLeft,
                                  duration: const Duration(milliseconds: 150),
                                  reverseDuration:
                                      const Duration(milliseconds: 150),
                                ),
                              );
                            },
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
