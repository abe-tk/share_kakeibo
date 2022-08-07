/// components
import 'package:share_kakeibo/components/number_format.dart';

/// view
import 'package:share_kakeibo/view/edit_event/edit_income_page.dart';
import 'package:share_kakeibo/view/edit_event/edit_spending_page.dart';

/// view_model
import 'package:share_kakeibo/view_model/calendar/calendar_view_model.dart';

/// packages
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class CalendarPage extends StatefulHookConsumerWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  void initState() {
    super.initState();
    Future(() async {
      await ref.read(calendarViewModelProvider).fetchRoomCode();
      ref.read(calendarViewModelProvider).fetchEvent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarViewModel = ref.watch(calendarViewModelProvider);

    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(calendarViewModel.eventMap);

    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.7,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
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
                    headerStyle: const HeaderStyle(
                      leftChevronIcon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.grey,
                      ),
                      rightChevronIcon: Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      ),
                      titleCentered: true,
                      formatButtonVisible: false,
                    ),
                    // 曜日の高さ
                    daysOfWeekHeight: 20,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(DateFormat.MMMEd('ja').format(_selectedDay)),
                      const Divider(),
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: _getEventForDay(_selectedDay)
                            .map(
                              (event) => Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      event.smallCategory,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            Text('：${event.paymentUser}'),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.edit,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            Text('：${event.memo ?? ''}'),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // leading: Icon(Icons.category),
                                    trailing: Text(
                                      (event.largeCategory == '収入')
                                          ? '${formatter.format(int.parse(event.price))} 円'
                                          : '- ${formatter.format(int.parse(event.price))} 円',
                                      style: TextStyle(
                                          color: (event.largeCategory == '収入')
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    onTap: () async {
                                      await Navigator.push(
                                        context,
                                        PageTransition(
                                          child: (event.largeCategory == '収入')
                                              ? EditIncomePage(event)
                                              : EditSpendingPage(event),
                                          type: PageTransitionType.rightToLeft,
                                          duration:
                                              const Duration(milliseconds: 150),
                                          reverseDuration:
                                              const Duration(milliseconds: 150),
                                        ),
                                      );
                                    },
                                  ),
                                  const Divider(),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}
