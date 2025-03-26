import 'package:flutter/material.dart';
import 'package:frontend/models/booking.dart';
import 'screens/main_screen.dart';
import 'screens/new_booking_screen.dart';
import 'screens/booking_list_screen.dart';

void main() {
  runApp(CalendarApp());
}

class CalendarApp extends StatelessWidget {
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
          case '/newBooking':
            return MaterialPageRoute(builder: (_) => NewBookingScreen());
          case '/bookingsList':
            // Ожидаем, что аргументы будут списком бронирований (Booking)
            final args = settings.arguments as List<Booking>? ?? [];
            return MaterialPageRoute(
              builder: (_) => BookingsListScreen(bookings: args),
            );
          default:
            return MaterialPageRoute(builder: (_) => MainScreen());
        }
      },
      theme: ThemeData(primarySwatch: Colors.blue),
    );
  }
}
