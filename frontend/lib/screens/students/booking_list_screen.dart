import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/appointment.dart';

class ApptsListScreen extends StatelessWidget {
  final List<Appointment> appointment;
  const ApptsListScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    // Сортируем записи по дате
    List<Appointment> sortedBookings = List.from(appointment);
    sortedBookings.sort((a, b) => a.startsAt.compareTo(b.startsAt));

    return Scaffold(
      appBar: AppBar(title: Text('Список записей')),
      body: ListView.builder(
        itemCount: sortedBookings.length,
        itemBuilder: (context, index) {
          final appt = sortedBookings[index];
          return ListTile(
            title: Text(DateFormat.yMd().add_jm().format(appt.startsAt)),
            subtitle: Text('Преподаватель: ${appt.teacherName}'),
            onTap: () {
              // Можно добавить переход к детальной информации о записи
            },
          );
        },
      ),
    );
  }
}
