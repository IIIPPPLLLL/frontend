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

  static Future<http.Response> age(
      int age,
      String token, // Tambahkan parameter token
      ) {
    return http.put(
      Uri.parse('$baseUrl/user/age/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header Authorization
      },
      body: jsonEncode({
        'age': age,
      }),
    );
  }

  static Future<http.Response> height(
      int height,
      String token, // Tambahkan parameter token
      ) {
    return http.patch(
      Uri.parse('$baseUrl/user/health/profile/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header Authorization
      },
      body: jsonEncode({
        'height': height,
      }),
    );
  }

  static Future<http.Response> weight(
      int weight,
      String token, // Tambahkan parameter token
      ) {
    return http.patch(
      Uri.parse('$baseUrl/user/health/profile/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header Authorization
      },
      body: jsonEncode({
        'weight': weight,
      }),
    );
  }

  static Future<http.Response> physicalActivity(
      String activity_level,
      String token, // Tambahkan parameter token
      ) {
    return http.put(
      Uri.parse('$baseUrl/user/physical_activity/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header Authorization
      },
      body: jsonEncode({
        'physical_activity_level': activity_level,
      }),
    );
  }

  static Future<http.Response> profile(
    String token
      ){
    return http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header Authorization
      });
  }

  static Future<http.Response> goal(
      String goal,
      String token, // Tambahkan parameter token
      ) {
    return http.put(
      Uri.parse('$baseUrl/user/goal/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Tambahkan header Authorization
      },
      body: jsonEncode({
        'goal': goal,
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