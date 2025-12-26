import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../helper/auth_helper.dart';

class ChatBotResponse {
  final String reply;
  final List<dynamic> actions;

  ChatBotResponse({required this.reply, required this.actions});
}
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

  static Future<http.Response> getMeals(
      String token
      ){
    return http.get(
        Uri.parse('$baseUrl/user/meals/getAll'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan header Authorization
        });
  }

  static Future<http.Response> eatSchedule(
      String token,
      Map<String, dynamic> scheduleData,
      ) {
    return http.post(
      Uri.parse('$baseUrl/schedules/eat/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(scheduleData),
    );
  }

  static Future<http.Response> getEatSchedule(
      String token
      ){
    return http.get(
        Uri.parse('$baseUrl/schedules/eat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan header Authorization
        });
  }

  static Future<http.Response> deleteEatSchedule(String token, String scheduleId) async {
    final url = Uri.parse('$baseUrl/schedules/eat/delete/$scheduleId');
    print('🗑️ DELETE Request URL: $url');
    print('🗑️ Deleting schedule ID: $scheduleId');
    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<http.Response> shoppingList(String token, Map<String, dynamic> shoppingData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/schedules'), // Sesuaikan endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(shoppingData),
      );
      return response;
    } catch (e) {
      print('Error in shoppingList: $e');
      rethrow;
    }
  }

  static Future<http.Response> getShoppingList(
      String token
      ){
    return http.get(
        Uri.parse('$baseUrl/schedules/getSchedule'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan header Authorization
        });
  }

  static Future<http.Response> deleteShoppingList(String token, String listId) async {
    final url = Uri.parse('$baseUrl/schedules/delete/$listId');
    return await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<http.Response> foodPreferences({
    required List<String> preferredFoods,
    required List<String> allergies,
    required String token,
  }) {
    return http.patch(
      Uri.parse('$baseUrl/user/preferences/food'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'preferred_foods': preferredFoods,
        'allergies': allergies,
      }),
    );
  }

  static Future<http.Response> getRecommendations(
      String token
      ){
    return http.get(
        Uri.parse('$baseUrl/user/recommendations/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan header Authorization
        });
  }

  static Future<Object> getNotifications(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/notifications?limit=50'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🔔 Get Notifications Status: ${response.statusCode}'); // Debug
      print('🔔 Response Body: ${response.body}'); // Debug

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Cek struktur response dari backend
        print('🔔 Response Structure: ${responseData.keys.toList()}');

        // Kemungkinan struktur response:
        // 1. Langsung array: [ {...}, {...} ]
        // 2. Object dengan data key: { "data": [...], "status": "success" }

        if (responseData.containsKey('data')) {
          return responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          return responseData;
        } else {
          // Coba cek jika ada key lain
          final List<String> keys = responseData.keys.toList();
          for (final key in keys) {
            if (responseData[key] is List) {
              return responseData[key] as List<dynamic>;
            }
          }
          return [];
        }
      } else {
        print('❌ Error: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('❌ Exception in getNotifications: $e');
      return [];
    }
  }

  static Future<bool> createNotification({
    required String token,
    required String title,
    String? message,
    String? icon,
  }) async {
    final url = Uri.parse('$baseUrl/notifications');

    final body = jsonEncode({
      "title": title,
      if (message != null) "message": message,
      if (icon != null) "icon": icon,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // menambahkan token
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Notifikasi berhasil dibuat: ${response.body}');
        return true;
      } else {
        print('Gagal membuat notifikasi: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error saat membuat notifikasi: $e');
      return false;
    }
  }

  static Future<void> readNotification(String token, String notificationId) async {
    final url = Uri.parse('$baseUrl/notifications/$notificationId/read');

    final response = await http.patch(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      // Berhasil menandai notif sebagai dibaca
      final result = jsonDecode(response.body);
      if (result['status'] != 'success') {
        throw Exception('Gagal menandai notifikasi dibaca');
      }
    } else if (response.statusCode == 404) {
      throw Exception('Notifikasi tidak ditemukan');
    } else {
      throw Exception('Gagal menandai notifikasi dibaca: ${response.statusCode}');
    }
  }

  static Future<ChatBotResponse> askChatBot(String token, String message) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chatbot/ask'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'message': message}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResp = jsonDecode(response.body);

      if (jsonResp['success'] == true && jsonResp['data'] != null) {
        final data = jsonResp['data'];
        return ChatBotResponse(
          reply: data['reply'] ?? '',
          actions: data['actions'] ?? [],
        );
      } else {
        throw Exception('Backend gagal merespon dengan benar.');
      }
    } else {
      throw Exception('Request gagal dengan status code ${response.statusCode}');
    }
  }

  static Future<http.Response> getHistoryChatBot(
      String token
      ){
    return http.get(
        Uri.parse('$baseUrl/chatbot/history'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
  }

  static Future<bool> checkProfileStatus() async {
    final token = await AuthHelper.getToken();

    if (token == null) return false;

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/profile/status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final isCompleted = data['profile_completed'] ?? false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isProfileCompleted', isCompleted);

        return isCompleted;
      }
      return false;
    } catch (e) {
      return false;
    }
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


