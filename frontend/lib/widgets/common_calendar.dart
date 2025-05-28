import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

typedef DaySelectedCallback =
    void Function(DateTime selectedDay, DateTime focusedDay);
typedef EventLoader = List<dynamic> Function(DateTime day);

class CommonCalendar extends StatefulWidget {
  final DateTime initialFocusedDay;
  final DateTime initialSelectedDay;
  final DaySelectedCallback onDaySelected;

  /// Флаг, показывать ли заголовок календаря
  final bool headerVisible;

  /// Формат календаря: месяц, неделя и т.д.
  final CalendarFormat calendarFormat;

  /// Фиксированная высота одной строки календаря (если нужно)
  final double? rowHeight;

  /// Функция, которая для заданного дня возвращает список событий (например, чтобы ставить маркеры)
  final EventLoader? eventLoader;

  /// Стиль заголовка календаря
  final HeaderStyle? headerStyle;

  /// Стиль календаря (для дат)
  final CalendarStyle? calendarStyle;

  /// Стиль дней недели (пн, вт и т.д.)
  final DaysOfWeekStyle? daysOfWeekStyle;

  const CommonCalendar({
    super.key,
    required this.initialFocusedDay,
    required this.initialSelectedDay,
    required this.onDaySelected,
    this.headerVisible = true,
    this.calendarFormat = CalendarFormat.month,
    this.rowHeight,
    this.eventLoader,
    this.headerStyle,
    this.calendarStyle,
    this.daysOfWeekStyle,
  });

  @override
  _CommonCalendarState createState() => _CommonCalendarState();
}

class _CommonCalendarState extends State<CommonCalendar> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.initialFocusedDay;
    _selectedDay = widget.initialSelectedDay;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      calendarFormat: widget.calendarFormat,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerVisible: widget.headerVisible,
      rowHeight: widget.rowHeight ?? 40,
      eventLoader: widget.eventLoader ?? (_) => [],
      headerStyle:
          widget.headerStyle ??
          HeaderStyle(formatButtonVisible: false, titleCentered: true),
      calendarStyle:
          widget.calendarStyle ??
          CalendarStyle(
            defaultDecoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(5.0),
            ),
          ),
      daysOfWeekStyle:
          widget.daysOfWeekStyle ??
          DaysOfWeekStyle(
            weekdayStyle: TextStyle(fontSize: 12, color: Colors.black),
            weekendStyle: TextStyle(fontSize: 12, color: Colors.black),
          ),
      selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDaySelected(selectedDay, focusedDay);
      },
    );
  }
}
