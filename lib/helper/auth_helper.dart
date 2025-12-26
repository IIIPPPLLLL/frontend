// helper/auth_helper.dart
import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  // Cek apakah sudah onboard
  static Future<bool> hasOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('hasOnboarded') ?? false;
  }

  // Set status onboard
  static Future<void> setOnboarded() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasOnboarded', true);
  }

  // Cek apakah sudah login (ada token)
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null && token.isNotEmpty;
  }

  // Cek apakah profile sudah lengkap
  static Future<bool> isProfileCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isProfileCompleted') ?? false;
  }

  // Simpan token
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Update status profile
  static Future<void> updateProfileStatus(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isProfileCompleted', completed);
  }

  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('isProfileCompleted');
    // Note: Jangan hapus 'hasOnboarded' agar tidak perlu onboarding lagi
  }

  // Ambil token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}