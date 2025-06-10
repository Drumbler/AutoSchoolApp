import 'package:flutter/material.dart';
import 'package:frontend/models/appointment.dart';
import 'screens/students/main_screen.dart';
import 'screens/students/new_booking_screen.dart';
import 'screens/students/booking_list_screen.dart';

void main() {
  runApp(CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AutoSchoolApp',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => MainScreen());
          case '/newAppointment':
            return MaterialPageRoute(builder: (_) => NewBookingScreen());
          case '/appointmentsList':
            // Ожидаем, что аргументы будут списком бронирований (Booking)
            final args = settings.arguments as List<Appointment>? ?? [];
            return MaterialPageRoute(
              builder: (_) => ApptsListScreen(appointment: args),
            );
          default:
            return MaterialPageRoute(builder: (_) => MainScreen());
        }
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
