// import 'package:flutter/material.dart';
// import 'package:frontend/models/booking.dart';
// import 'package:frontend/utils/calendar_logic.dart';
// import 'package:frontend/utils/database_helper.dart';

// class BookingListWidget extends StatefulWidget {
//   final List<Booking> bookings;
//   const BookingListWidget({super.key, required this.bookings});

//   @override
//   _BookingListWidgetState createState() => _BookingListWidgetState();
// }

// class _BookingListWidgetState extends State<BookingListWidget> {
//   Map<int, String> teacherNames = {}; // Кэш инструкторов

//   @override
//   void initState() {
//     super.initState();
//     _loadTeacherNames();
//   }

//   Future<void> _loadTeacherNames() async {
//     for (var booking in widget.bookings) {
//       if (!teacherNames.containsKey(booking.teacherId)) {
//         String name = await DatabaseHelper.getTeacherName(booking.teacherId);
//         setState(() {
//           teacherNames[booking.teacherId] = name;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.bookings.isEmpty) {
//       return Center(child: Text("Нет записей"));
//     }
//     return ListView.builder(
//       itemCount: widget.bookings.length,
//       itemBuilder: (context, index) {
//         final booking = widget.bookings[index];
//         final teacherName = teacherNames[booking.teacherId] ?? "Загрузка...";

//         return Card(
//           margin: EdgeInsets.symmetric(vertical: 5),
//           child: ListTile(
//             title: Text('Запись на ${CalendarLogic.formatDate(booking.date)}'),
//             subtitle: Text(
//               'Время: ${CalendarLogic.formatTime(booking.time)}\nПреподаватель: $teacherName',
//             ),
//             trailing: Icon(Icons.school),
//           ),
//         );
//       },
//     );
//   }
// }
