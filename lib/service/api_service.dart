import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Future<http.Response> login(
      String identifier,
      String password,
      ) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'), // sesuaikan endpoint backend
      headers: {'Content-Type': 'application/json',},
      body: jsonEncode({
        'username': identifier,
        'password': password,
      }),
    );
  }
  static Future<http.Response> register(
      String username,
      String email,
      String password,
      ) {
    return http.post(
      Uri.parse('$baseUrl/auth/register'), // sesuaikan endpoint backend
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
  }

}
