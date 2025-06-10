import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
// import 'package:flutter_login/theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _storage = FlutterSecureStorage();
const _apiUrl = 'http://localhost:8080';

Future<String?> _authUser(LoginData data) async {
  final response = await http.post(
    Uri.parse("$_apiUrl/auth/login"),
    headers: {'Content-type': 'application/x-www-form-urlencoded'},
    body: {'username': data.name, 'password': data.password},
  );

  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final token = body['access_token'] as String;

    await _storage.write(key: 'jwt', value: token);
    return null;
  } else {
    final err =
        jsonDecode(response.body)['detail'] as String? ?? 'Ошибка Входа';
    return err;
  }
}

Future<String?> _signupUser(SignupData data) async {
  final response = await http.post(
    Uri.parse('$_apiUrl/auth/register'),
    headers: {'Content-type': 'application/x-www-form-urlencoded'},
    body: jsonEncode({'username': data.name, 'password': data.password}),
  );

  if (response.statusCode == 201) {
    return _authUser(LoginData(name: data.name!, password: data.password!));
  } else {
    final err =
        jsonDecode(response.body)['detail'] as String? ?? 'Ошибка регистрации';
    return err;
  }
}

Future<String?> _recoverPassword(String email) async {
  final response = await http.post(
    Uri.parse('$_apiUrl/auth/forgot-password'),
    headers: {'Content-type': 'application/x-www-form-urlencoded'},
    body: {'email': email},
  );

  if (response.statusCode == 200) {
    return null;
  } else {
    final err =
        jsonDecode(response.body)['detail'] as String? ??
        'Ошибка восстановления пароля';
    return err;
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Autoschool',
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacementNamed('/home');
      },
      messages: LoginMessages(
        userHint: 'Логин',
        passwordHint: 'Пароль',
        loginButton: 'Войти',
        signupButton: 'Зарегистрироваться',
        recoverPasswordButton: 'Забыли пароль',
      ),
    );
  }
}
