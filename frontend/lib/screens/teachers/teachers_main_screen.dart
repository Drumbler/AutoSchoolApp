import 'package:flutter/material.dart';
import 'package:frontend/models/appointment.dart';
import 'package:frontend/utils/api_client.dart';
import 'package:frontend/widgets/common_calendar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/widgets/app_tile.dart';

class TeachersMainScreen extends StatefulWidget {
  const TeachersMainScreen({super.key});

  @override
  _TeacherMainScreenState createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeachersMainScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  List<Appointment> _appointments = [];
  Appointment? _nextAppointment;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final list = await ApiClient.fetchTeacherAppointments();
    setState(() {
      _appointments = list;
      _computeNextAppointment();
    });
  }

  void _computeNextAppointment() {
    final now = DateTime.now();
    final upcoming =
        _appointments.where((a) => a.startsAt.isAfter(now)).toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    _nextAppointment = upcoming.isNotEmpty ? upcoming.first : null;
  }

  List<dynamic> _eventsForDay(DateTime day) {
    return _appointments.any(
          (a) =>
              a.startsAt.year == day.year &&
              a.startsAt.month == day.month &&
              a.startsAt.day == day.day,
        )
        ? ['appt']
        : [];
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final tileHeigh = screenHeight / 6;
    final dateAppointments =
        _appointments
            .where(
              (a) =>
                  a.startsAt.year == _selectedDay.year &&
                  a.startsAt.month == _selectedDay.month &&
                  a.startsAt.day == _selectedDay.day,
            )
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Главное меню - Инструктор')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: tileHeigh,
              child: CommonCalendar(
                initialFocusedDay: _focusedDay,
                initialSelectedDay: _selectedDay,
                onDaySelected: _onDaySelected,
                headerVisible: false,
                calendarFormat: CalendarFormat.week,
                rowHeight: 40,
                eventLoader: _eventsForDay,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  defaultTextStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  weekendTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.shade200,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontSize: 12, color: Colors.white),
                  weekendStyle: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // записи на конкретный день
            AppTile(
              color: Colors.orangeAccent,
              title: 'Мои записи',
              subtitle:
                  dateAppointments.isEmpty
                      ? 'Нет записей'
                      : '${dateAppointments.length} записей',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/teacher/appointments',
                  arguments: _selectedDay,
                );
              },
              height: tileHeigh,
            ),
            // Создание новой записи
            AppTile(
              color: Colors.greenAccent,
              title: 'Создать новую запись',
              onTap: () {
                Navigator.pushNamed(context, '/teacher/newAppointment');
              },
              height: tileHeigh,
            ),

            // ближайшая запись
            AppTile(
              color: Colors.lightBlueAccent,
              title: 'Ближайшая запись',
              subtitle:
                  _nextAppointment == null
                      ? 'Нет'
                      : DateFormat(
                        'dd.MM.yyyy - HH:mm',
                      ).format(_nextAppointment!.startsAt),
              onTap: () {
                if (_nextAppointment != null) {
                  Navigator.pushNamed(
                    context,
                    '/teacher/appointments/details',
                    arguments: _nextAppointment!.id,
                  );
                }
              },
              height: tileHeigh,
            ),
          ],
        ),
      ),
    );
  }
}
