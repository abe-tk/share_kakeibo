import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:share_kakeibo/impoter.dart';

class AppTableCalendar extends StatelessWidget {
  final DateTime focused;
  final DateTime selected;
  final dynamic eventLoader;
  final List<dynamic> Function(DateTime) getEventForDay;
  final Function onDaySelected;

  const AppTableCalendar({
    Key? key,
    required this.focused,
    required this.selected,
    required this.eventLoader,
    required this.getEventForDay,
    required this.onDaySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      shouldFillViewport: true,
      locale: 'ja_JP',
      firstDay: DateTime(2000),
      lastDay: DateTime(2050),
      focusedDay: focused,
      eventLoader: eventLoader,
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
        return isSameDay(selected, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(selected, selectedDay)) {
          onDaySelected(selectedDay, focusedDay);
          getEventForDay(selectedDay);
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
    );
  }
}

// 日付に表示するイベントのバッチ
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

