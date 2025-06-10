import 'package:flutter/material.dart';
import 'package:frontend/models/appointment.dart';
import 'package:frontend/utils/api_client.dart';

class TeachersMainScreen extends StatefulWidget {
  const TeachersMainScreen({super.key});

  @override
  _TeacherMainScreenState createState() => _TeacherMainScreenState();
}

class _TeacherMainScreenState extends State<TeachersMainScreen> {
  DateTime _selectedDate = DateTime.now();
  List<Appointment> _appointments = [];
  Appointment? _nextAppointment;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }
}
