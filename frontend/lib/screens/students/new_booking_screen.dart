import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:frontend/widgets/common_calendar.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});
  @override
  _NewBookingScreenState createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  final List<String> teachers = ['Mr. Smith', 'Mrs. Johnson', 'Ms. Davis'];
  String? _selectedTeacher;

  @override
  void initState() {
    super.initState();
    _selectedTeacher = teachers[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Создать запись')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Используем общий календарь с заголовком
            CommonCalendar(
              initialFocusedDay: _focusedDate,
              initialSelectedDay: _selectedDate,
              onDaySelected: (selected, focused) {
                setState(() {
                  _selectedDate = selected;
                  _focusedDate = focused;
                });
              },
              headerVisible: true,
              calendarFormat: CalendarFormat.month,
              rowHeight: 40,
              // Здесь можно передать стили, отличающиеся от главного экрана
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(fontSize: 16, color: Colors.black),
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(fontSize: 15, color: Colors.black),
                weekendTextStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(fontSize: 15, color: Colors.black),
                weekendStyle: TextStyle(fontSize: 15, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Выберите преподавателя:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _selectedTeacher,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTeacher = newValue;
                });
              },
              items:
                  teachers.map<DropdownMenuItem<String>>((String teacher) {
                    return DropdownMenuItem<String>(
                      value: teacher,
                      child: Text(teacher),
                    );
                  }).toList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Логика создания записи здесь
                Navigator.pop(context);
              },
              child: Text('Создать запись'),
            ),
          ],
        ),
      ),
    );
  }
}
