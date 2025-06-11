import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/models/appointment.dart';
import 'package:frontend/models/user.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'http://localhost:8080';

  static const _tokenKey = 'jwt';

  static final _storage = FlutterSecureStorage();

  static Future<Map<String, String>> _headers({bool json = true}) async {
    final token = await _storage.read(key: _tokenKey);
    final headers = <String, String>{
      if (json) 'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
    return headers;
  }

  // AUTHENTIFICATION

  static Future<void> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/register');
    final resp = await http.post(
      uri,
      headers: await _headers(),
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
    if (resp.statusCode != 201) {
      final err = jsonDecode(resp.body)['detail'] ?? 'Registration failed';
      throw Exception(err);
    }
  }

  static Future<void> login({
    required String username,
    required String password,
  }) async {
    final uri = Uri.parse('$_baseUrl/auth/login');
    final resp = await http.post(
      uri,
      headers: await _headers(),
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      final token = data['access_token'];
      await _storage.write(key: _tokenKey, value: token);
    } else {
      final err = jsonDecode(resp.body)['detail'] ?? 'Login failed';
      throw Exception(err);
    }
  }

  static Future<User> get_current_user() async {
    final uri = Uri.parse('$_baseUrl/auth/me');
    final resp = await http.get(uri, headers: await _headers());
    if (resp.statusCode == 200) {
      return User.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  static Future<List<Appointment>> fetchAppointments({DateTime? date}) async {
    final uri =
        date != null
            ? Uri.parse(
              '$_baseUrl/appointments?date_filter=${date.toIso8601String()}',
            )
            : Uri.parse('$_baseUrl/appointments');
    final resp = await http.get(uri, headers: await _headers());
    if (resp.statusCode == 200) {
      final List list = jsonDecode(resp.body);
      return list.map((e) => Appointment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  static Future<List<Appointment>> fetchTeacherAppointments({DateTime? date}) async {
    final uri =
        date != null
            ? Uri.parse(
              '$_baseUrl/appointments/teacher?date_filter=${date.toIso8601String()}',
            )
            : Uri.parse('$_baseUrl/appointments/teacher');
    final resp = await http.get(uri, headers: await _headers());
    if (resp.statusCode == 200) {
      final List list = jsonDecode(resp.body);
      return list.map((e) => Appointment.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load appointments');
    }
  }

  static Future<Appointment> createAppointment(Appointment appt) async {
    final uri = Uri.parse('$_baseUrl/appointments');
    final resp = await http.post(
      uri,
      headers: await _headers(),
      body: jsonEncode(appt.toJson()),
    );
    if (resp.statusCode == 201) {
      return Appointment.fromJson(jsonDecode(resp.body));
    } else {
      final err =
          jsonDecode(resp.body)['detail'] ?? 'Failed to create appointment';
      throw Exception(err);
    }
  }

  static Future<void> deleteAppointment(int id) async {
    final uri = Uri.parse('$_baseUrl/appointments/$id');
    final resp = await http.delete(uri, headers: await _headers());
    if (resp.statusCode != 204) {
      final err =
          jsonDecode(resp.body)['detail'] ?? 'Failed to delete appointment';
      throw Exception(err);
    }
  }
}
