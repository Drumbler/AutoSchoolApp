import 'package:flutter/material.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/widgets/booking_list_widget.dart';
import 'package:frontend/widgets/booking_widget.dart';
import 'package:frontend/screens/booking_screen.dart';
import 'package:frontend/widgets/calendar_widget.dart';

class MainScreen extends StatefulWidget {
  final int studentId;

  const MainScreen({super.key, required this.studentId});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime selectedDate = DateTime.now();
  List<Booking> bookings = [];

  void _addBooking(DateTime date, TimeOfDay time, int teacherId) {
    setState(() {
      bookings.add(
        Booking(
          bookingId: bookings.length + 1,
          studentId: widget.studentId,
          teacherId: teacherId,
          date: date,
          time: time,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Главное меню')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Календарь записей', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            CalendarWidget(
              selectedDate: selectedDate,
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
              onDaySelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },  
            ),
            
          ],
        ),
      )
    );
  }
}
