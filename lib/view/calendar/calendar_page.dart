import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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
      ref.read(calendarEventStateProvider.notifier).fetchCalendarEvent(ref.read(eventProvider));
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarEventState = ref.watch(calendarEventStateProvider);
    final _focusedDay = useState(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day));
    final _selectedDay = useState(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toUtc().add(const Duration(hours: 9)));

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(calendarEventState);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    bool checkExistenceEvent(DateTime selectedDate) {
      bool value = true;
      for (final eventDate in calendarEventState.keys) {
        if (eventDate.toUtc().add(const Duration(hours: 9)) == selectedDate) {
          value = false;
          break;
        }
      }
      return value;
    }

    return Scaffold(
      appBar: ActionAppBar(
        title: 'カレンダー',
        icon: Icons.receipt_long,
        iconColor: Colors.black,
        function: () => Navigator.pushNamed(context, '/detailEventPage'),
      ),
      drawer: const DrawerMenu(),
      body: SafeArea(
        child: Column(
          children: [
            // カレンダーの表示
            AppTableCalendar(
              focused: _focusedDay.value,
              selected: _selectedDay.value,
              eventLoader: _getEventForDay,
              getEventForDay: _getEventForDay,
              onDaySelected: (selectedDay, focusedDay) {
                _selectedDay.value = selectedDay;
                _focusedDay.value = focusedDay;
              },
            ),
            // 選択している日付
            Material(
              elevation: 3,
              child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
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
            ),
            // 選択した日付のイベントがなければ表示
            Visibility(
              visible: checkExistenceEvent(_selectedDay.value),
              child: const NoDataCaseImg(text: '取引', height: 36),
            ),
            // 選択した日付のイベントを表示
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1.0),
                child: ListView(
                  children: _getEventForDay(_selectedDay.value).map((event) => Column(
                    children: [
                      CalendarEventList(
                        price: event.price,
                        largeCategory: event.largeCategory,
                        smallCategory: event.smallCategory,
                        paymentUser: event.paymentUser,
                        memo: event.memo,
                        function: () {
                          ref.read(paymentUserProvider.notifier).fetchPaymentUser(ref.read(roomMemberProvider));
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EditEventPage(event: event);
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
