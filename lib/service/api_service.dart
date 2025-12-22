import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static Future<http.Response> login(
      String identifier,
      String password,
      ) {
    return http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
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
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );
  }

  static Future<http.Response> gender(
      String gender,
      String token, // Tambahkan parameter token
      ) {
    return http.put(
      Uri.parse('$baseUrl/user/gender/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header Authorization
      },
      body: jsonEncode({
        'gender': gender,
      }),
    );
  }

  // OPTIONAL: Method untuk cek apakah token valid
  static Future<http.Response> verifyToken(String token) {
    return http.get(
      Uri.parse('$baseUrl/auth/verify'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
  }
}