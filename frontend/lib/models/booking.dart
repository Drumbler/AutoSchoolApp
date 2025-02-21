import 'package:flutter/material.dart';

class Booking {
  final int bookingId;
  final int teacherId;
  final int studentId;
  final DateTime date;
  final TimeOfDay time;

  Booking({
    required this.bookingId,
    required this.teacherId,
    required this.studentId,
    required this.date,
    required this.time,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['booking_id'],
      teacherId: json['teacher_id'],
      studentId: json['student_id'],
      date: DateTime.parse(json['date']),
      time: TimeOfDay(
        hour: int.parse(json['time'].split(":")[0]),
        minute: int.parse(json['time'].split(":")[0]),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookind_id': bookingId,
      'student_id': studentId,
      'teacher_id': teacherId,
      'date': date.toIso8601String(),
      'time': "${time.hour}: ${time.minute}",
    };
  }
}
