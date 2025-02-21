import 'package:flutter/material.dart';

class CalendarLogic {
  static TimeOfDay defaultTime = const TimeOfDay(hour: 12, minute: 0);

  static String formatDate(DateTime date) {
    return "${date.toLocal()}".split(' ')[0];

  }
  static String formatTime(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }
}
