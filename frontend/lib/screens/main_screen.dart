import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/widgets/common_calendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/models/booking.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  // Пример списка записей (Booking)
  final List<Booking> bookings = [
    Booking(
      dateTime: DateTime.now().add(Duration(hours: 2)),
      teacher: 'Mr. Smith',
    ),
    Booking(
      dateTime: DateTime.now().add(Duration(hours: 6)),
      teacher: 'Mrs. Johnson',
    ),

    Booking(
      dateTime: DateTime.now().add(Duration(days: 1, hours: 3)),
      teacher: 'Mrs. Johnson',
    ),
    Booking(
      dateTime: DateTime.now().add(Duration(days: 2, hours: 1)),
      teacher: 'Ms. Davis',
    ),
  ];

  Booking? _getNearestBooking() {
    final now = DateTime.now();
    final upcoming = bookings.where((b) => b.dateTime.isAfter(now)).toList();
    if (upcoming.isEmpty) return null;
    upcoming.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return upcoming.first;
  }

  List<Booking> _getBookingsForDate(DateTime date) {
    return bookings
        .where(
          (b) =>
              b.dateTime.year == date.year &&
              b.dateTime.month == date.month &&
              b.dateTime.day == date.day,
        )
        .toList();
  }

  // Функция для eventLoader, которая возвращает событие, если день есть в bookingDates.
  List<dynamic> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    bool hasBooking = bookings.any(
      (booking) =>
          booking.dateTime.year == key.year &&
          booking.dateTime.month == key.month &&
          booking.dateTime.day == key.day,
    );
    return hasBooking ? ['booking'] : [];
  }

  @override
  Widget build(BuildContext context) {
    // Высота плитки календаря ~ 1/6 экрана
    double screenHeight = MediaQuery.of(context).size.height;
    double tileHeight = screenHeight / 6;

    return Scaffold(
      appBar: AppBar(title: Text('Главное меню')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Плитка с компактным календарем
            GestureDetector(
              onTap: () {
                // При необходимости можно добавить действие при нажатии.
              },
              child: Container(
                height: tileHeight,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orangeAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Подпись с названием месяца
                    Text(
                      DateFormat.yMMMM().format(_focusedDay),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
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
                        eventLoader: _getEventsForDay,
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
                          weekdayStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                          weekendStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Плитка для создания новой записи
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/newBooking');
              },
              child: Container(
                height: tileHeight,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    'Создать новую запись',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            // Плитка с ближайшей записью
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/bookingsList',
                  arguments: bookings,
                );
              },
              child: Container(
                height: tileHeight,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ближайшие записи',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildNearestBookingPreview(),
                  ],
                ),
              ),
            ),
            GestureDetector(
              child: Container(
                height: tileHeight,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Запись на выделенную дату',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    _buildTargetBookingsPreview(_selectedDay),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNearestBookingPreview() {
    Booking? nearest = _getNearestBooking();
    if (nearest == null) {
      return Text('Нет записей', style: TextStyle(fontSize: 12));
    }
    return Column(
      children: [
        Text(
          DateFormat.yMd().add_jm().format(nearest.dateTime),
          style: TextStyle(fontSize: 12),
        ),
        Text(
          'Преподаватель: ${nearest.teacher}',
          style: TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTargetBookingsPreview(DateTime date) {
    List<Booking> bookings = _getBookingsForDate(date);
    if (bookings.isEmpty) {
      return Text('Нет записей', style: TextStyle(fontSize: 14));
    }
    return Column(
      children:
          bookings.map((booking) {
            return Column(
              children: [
                Text(
                  DateFormat.yMd().add_jm().format(booking.dateTime),
                  style: TextStyle(fontSize: 14),
                ),
                Text(
                  booking.teacher,
                  style: TextStyle(
                    fontSize: 14,
                    decorationStyle: TextDecorationStyle.solid,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.black,
                  ),
                ),
              ],
            );
          }).toList(),
    );
  }
}
