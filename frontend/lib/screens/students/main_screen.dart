import 'package:flutter/material.dart';
import 'package:frontend/utils/api_client.dart';
import 'package:frontend/widgets/app_tile.dart';
import 'package:intl/intl.dart';
import 'package:frontend/widgets/common_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/models/appointment.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    final list = await ApiClient.fetchAppointments();
    setState(() {
      _appointments = list;
      _computeNextAppointment();
    });
  }

  // Пример списка записей (appointment)

  Appointment? _computeNextAppointment() {
    final now = DateTime.now();
    final upcoming =
        _appointments.where((a) => a.startsAt.isAfter(now)).toList()
          ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    _nextAppointment = upcoming.isNotEmpty ? upcoming.first : null;
  }

  // Функция для eventLoader, которая возвращает событие, если день есть в appointmentDates.
  List<dynamic> _eventsForDay(DateTime day) {
    bool hasAppointment = _appointments.any(
      (a) =>
          a.startsAt.year == day.year &&
          a.startsAt.month == day.month &&
          a.startsAt.day == day.day,
    );
    return hasAppointment ? ['appt'] : [];
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
    final tileHeight = screenHeight / 6;
    final dateAppointments = _appointments.where(
      (a) =>
          a.startsAt.year == _selectedDay.year &&
          a.startsAt.month == _selectedDay.month &&
          a.startsAt.day == _selectedDay.day,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Главное меню')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Плитка с компактным календарем
            SizedBox(
              height: tileHeight,
              child: CommonCalendar(
                initialFocusedDay: _focusedDay,
                initialSelectedDay: _selectedDay,
                onDaySelected: (selected, focused) {
                  setState(() {
                    _selectedDay = selected;
                    _focusedDay = focused;
                  });
                },
                headerVisible: false,
                calendarFormat: CalendarFormat.week,
                rowHeight: 40,
                eventLoader: _eventsForDay,
                // Можно задать свой стиль для компактного календаря:
                calendarStyle: CalendarStyle(
                  defaultDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  weekendDecoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  markersAlignment: Alignment.bottomRight,
                  markerMargin: EdgeInsets.only(right: 5, bottom: 5),
                  defaultTextStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  weekendTextStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent.shade200,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: TextStyle(fontSize: 15, color: Colors.white),
                  weekendStyle: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 16),

            AppTile(
              color: Colors.orangeAccent,
              title: 'Мои записи',
              subtitle:
                  dateAppointments.isEmpty
                      ? 'нет записей'
                      : '${dateAppointments.length} записей',
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/appointments',
                  arguments: _selectedDay,
                );
              },
              height: tileHeight,
            ),
            // Создание новой записи
            AppTile(
              color: Colors.greenAccent,
              title: 'Создать новую запись',
              onTap: () {
                Navigator.pushNamed(context, '/create_appointment');
              },
              height: tileHeight,
            ),
            // Предстоящая запись
            AppTile(
              color: Colors.blueAccent,
              title: 'Предстоящая запись',
              subtitle:
                  _nextAppointment == null
                      ? 'нет записей'
                      : DateFormat(
                        'dd.MM.yyyy - HH:mm',
                      ).format(_nextAppointment!.startsAt),
              onTap: () {
                if (_nextAppointment == null) {
                  Navigator.pushNamed(
                    context,
                    '/appointment_details',
                    arguments: _nextAppointment,
                  );
                }
              },
              height: tileHeight,
            ),
          ],
        ),
      ),
    );
  }
}
