import 'package:flutter/material.dart';
import 'package:frontend/utils/calendar_logic.dart';
import 'package:frontend/utils/database_helper.dart';

class BookingScreen extends StatefulWidget {
  final Function(DateTime, TimeOfDay, int) onBookingAdded;

  const BookingScreen({super.key, required this.onBookingAdded});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 12, minute: 0);
  int? selectedTeacherId;
  List<Map<String, dynamic>> teachers = [];

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  Future<void> _loadTeachers() async {
    final loadedTeachers = await DatabaseHelper.getAllTeachers();
    setState(() {
      teachers = loadedTeachers;
      if (teachers.isNotEmpty) {
        selectedTeacherId = teachers.first['id'];
      }
    });
  }

  void _selectDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2040),
    );
    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  void _selectTime() async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
      });
    }
  }

  void _confirmBooking() {
    if (selectedTeacherId != null) {
      widget.onBookingAdded(selectedDate, selectedTime, selectedTeacherId!);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Выберите преподавателя")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Запись на урок")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Выберите дату",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: _selectDate,
              child: Text(CalendarLogic.formatDate(selectedDate)),
            ),

            Text(
              "Выберите время",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: _selectTime,
              child: Text(CalendarLogic.formatTime(selectedTime)),
            ),

            Text(
              "Выберите преподавателя",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<int>(
              value: selectedTeacherId,
              items:
                  teachers.map((teacher) {
                    return DropdownMenuItem<int>(
                      value: teacher['id'],
                      child: Text(teacher['name']),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedTeacherId = value;
                });
              },
            ),

            Spacer(),

            Center(
              child: ElevatedButton(
                onPressed: _confirmBooking,
                child: Text("Подтвердить запись"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
