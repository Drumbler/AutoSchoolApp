import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  final bool isDarkMode;
  final DateTime selectedDate;
  final Function(DateTime) onDaySelected;
  const CalendarWidget({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
    required this.isDarkMode,
  });

  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {
  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
    widget.onDaySelected(day);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return TableCalendar(
      selectedDayPredicate: (day) => isSameDay(day, widget.selectedDate),
      locale: "ru_RU",
      // calendarFormat: ,
      rowHeight: 43,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: isDarkMode ? Color(0xfff0f0f0) : Color(0xff333333),
        ),
      ),
      availableGestures: AvailableGestures.all,
      focusedDay: today,
      firstDay: DateTime.utc(2010, 1, 1),
      lastDay: DateTime.utc(2040, 1, 1),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: _onDaySelected,
      calendarStyle: CalendarStyle(
        weekendTextStyle: TextStyle(
          color: isDarkMode ? Colors.red.shade300 : Colors.red,
        ),
        defaultTextStyle: TextStyle(
          color: isDarkMode ? Color(0xfff0f0f0) : Color(0xff333333),
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        outsideTextStyle: TextStyle(
          color: isDarkMode ? Colors.white24 : Colors.black26,
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(10),
        ),
        todayDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.transparent,
          border: Border.all(color: Color(0xfff98133), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        todayTextStyle: TextStyle(
          color: isDarkMode ? Color(0xfff0f0f0) : Color(0xff333333),
        ),
        selectedTextStyle: TextStyle(
          color: isDarkMode ? Color(0xfff0f0f0) : Color(0xff333333),
        ),
      ),
    );
  }
}
