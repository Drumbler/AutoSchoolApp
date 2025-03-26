import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:frontend/models/booking.dart';

class BookingsListScreen extends StatelessWidget {
  final List<Booking> bookings;
  const BookingsListScreen({Key? key, required this.bookings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Сортируем записи по дате
    List<Booking> sortedBookings = List.from(bookings);
    sortedBookings.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    
    return Scaffold(
      appBar: AppBar(title: Text('Список записей')),
      body: ListView.builder(
        itemCount: sortedBookings.length,
        itemBuilder: (context, index) {
          final booking = sortedBookings[index];
          return ListTile(
            title: Text(DateFormat.yMd().add_jm().format(booking.dateTime)),
            subtitle: Text('Преподаватель: ${booking.teacher}'),
            onTap: () {
              // Можно добавить переход к детальной информации о записи
            },
          );
        },
      ),
    );
  }
}
