import 'package:intl/intl.dart';

class Appointment {
  final int id;
  final DateTime startsAt;
  final DateTime createdAt;
  final String teacherName;
  final String studentName;

  Appointment({
    required this.id,
    required this.startsAt,
    required this.createdAt,
    required this.teacherName,
    required this.studentName,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] as int,
      startsAt: DateTime.parse(json['starts_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      teacherName: json['teacher_name'] as String,
      studentName: json['student_name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'starts_at': startsAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'teacher_name': teacherName,
      'student_name': studentName,
    };
  }

  Appointment copyWith({
    int? id,
    DateTime? startsAt,
    DateTime? createdAt,
    String? teacherName,
    String? studentName,
  }) {
    return Appointment(
      id: id ?? this.id,
      startsAt: startsAt ?? this.startsAt,
      createdAt: createdAt ?? this.createdAt,
      teacherName: teacherName ?? this.teacherName,
      studentName: studentName ?? this.studentName,
    );
  }

  String get formattedDate => DateFormat('dd.MM.yyyy').format(startsAt);
  String get formattedStartTime => DateFormat('HH:mm').format(startsAt);

  @override
  String toString() {
    return 'Appointment(id: $id, startsAt: $startsAt, createdAt: $createdAt, teacherName: $teacherName, studentName: $studentName)';
  }
}
