import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_kakeibo/importer.dart';
import 'package:table_calendar/table_calendar.dart';

int _getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // カレンダーのイベント
    final calendarEvent = ref.watch(calendarEventProvider);

    // 現在日付
    final _focusedDay = useState(
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    );

    // 選択日付
    final _selectedDay = useState(
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toUtc()
            .add(const Duration(hours: 9)));

    // カレンダーのイベントを日付ごとにまとめる
    final _events = LinkedHashMap<DateTime, List>(
      equals: isSameDay,
      hashCode: _getHashCode,
    )..addAll(calendarEvent);

    // 日付ごとのイベント
    List _getEventForDay(DateTime day) {
      return _events[day] ?? [];
    }

    // 選択した日付にイベントがあるかどうか
    bool _isThereEvents(DateTime selectedDate) {
      bool value = true;
      for (final eventDate in calendarEvent.keys) {
        if (eventDate.toUtc().add(const Duration(hours: 9)) == selectedDate) {
          value = false;
          break;
        }
      }
      return value;
    }

    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              // カレンダー
              CustomCalendar(
                focused: _focusedDay.value,
                selected: _selectedDay.value,
                eventLoader: _getEventForDay,
                getEventForDay: _getEventForDay,
                onDaySelected: (selectedDay, focusedDay) {
                  _selectedDay.value = selectedDay;
                  _focusedDay.value = focusedDay;
                },
              ),
              // 選択した日付のイベントがなければ表示
              NonDataCase(
                visible: _isThereEvents(_selectedDay.value),
                text: '取引',
              ),
              // 選択した日付のイベントを表示
              Expanded(
                child: ListView.builder(
                  itemCount: _getEventForDay(_selectedDay.value).length + 1,
                  itemBuilder: (context, index) {
                    if (index == _getEventForDay(_selectedDay.value).length) {
                      return const Gap(120);
                    }
                    return _getEventForDay(_selectedDay.value).map((event) {
                      return Column(
                        children: [
                          CalendarEventList(
                            price: event.price,
                            largeCategory: event.largeCategory,
                            smallCategory: event.smallCategory,
                            paymentUser: event.paymentUser,
                            memo: event.memo,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return UpsertEventPage(
                                      largeCategory: event.largeCategory,
                                      event: event,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    }).toList()[index];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
