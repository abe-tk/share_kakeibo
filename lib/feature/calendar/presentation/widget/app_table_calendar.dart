import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    return SizedBox(
      height: MediaQuery.of(context).size.width * 0.7,
      width: MediaQuery.of(context).size.width,
      child: TableCalendar(
        shouldFillViewport: true,
        locale: 'ja_JP',
        firstDay: DateTime(2000),
        lastDay: DateTime(2050),
        focusedDay: focused,
        eventLoader: eventLoader,
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekendStyle:  TextStyle(color: Colors.black45),
        ),
        calendarStyle: const CalendarStyle(
          weekendTextStyle: TextStyle(color: Colors.black45),
          outsideDaysVisible: false,
        ),
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
        headerStyle: const HeaderStyle(
          leftChevronIcon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.black87,
          ),
          rightChevronIcon: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.black87,
          ),
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          formatButtonVisible: false,
          headerPadding: EdgeInsets.all(0),
          leftChevronPadding: EdgeInsets.all(0),
          leftChevronMargin: EdgeInsets.all(0),
          rightChevronPadding: EdgeInsets.all(0),
          rightChevronMargin: EdgeInsets.all(0),
        ),
        // 曜日の高さ
        daysOfWeekHeight: 20,
      ),
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
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: CustomColor.biBackGroundColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: CustomColor.biTextColor,
            fontSize: 12.0,
          ),
        ),
      ),
    ),
  );
}
