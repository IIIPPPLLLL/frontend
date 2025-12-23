import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../routes/app_routes.dart';
import '../service/api_service.dart';

class ActivityLevel extends StatefulWidget {
  const ActivityLevel({super.key});

  @override
  State<ActivityLevel> createState() => _ActivityLevelState();
}

class _ActivityLevelState extends State<ActivityLevel> {
  String? _selected; // Akan berisi 'Beginner', 'Intermediate', atau 'Advance'
  bool _isLoading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('🔐 Token loaded: ${token != null ? "Yes" : "No"}');
    setState(() {
      _token = token;
    });
  }

  Widget _optionButton({
    required String value,
    required String label,
  }) {
    final bool isSelected = _selected == value;

    return GestureDetector(
      onTap: _isLoading ? null : () {
        print('🎯 Button tapped: "$value"');
        setState(() => _selected = value);
      },
      child: Opacity(
        opacity: _isLoading ? 0.6 : 1.0,
        child: Container(
          width: double.infinity,
          height: 64,
          padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF588D6E) : Colors.white,
            borderRadius: BorderRadius.circular(38),
          ),
          child: Center(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF588D6E),
                fontSize: 24,
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleContinue() async {
    // Debug _selected value
    print('\n🔍 === CONTINUE BUTTON PRESSED ===');
    print('_selected value: "$_selected"');
    print('_selected type: ${_selected?.runtimeType}');
    print('_selected length: ${_selected?.length}');

    if (_selected == null) {
      print('❌ _selected is NULL');
      _showErrorSnackbar('Please select an activity level');
      return;
    }

    if (_token == null) {
      print('❌ Token is NULL');
      _showErrorSnackbar('Session expired. Please login again.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Convert value to UPPERCASE sebelum dikirim
      final uppercaseValue = _selected!.toUpperCase();
      print('✅ Uppercase value: "$uppercaseValue"');

      // Kirim ke backend
      print('🚀 Sending to API...');
      final response = await ApiService.physicalActivity(uppercaseValue, _token!);

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ API Success!');

        _showSuccessSnackbar();

        await Future.delayed(const Duration(milliseconds: 300));

        Navigator.pushNamed(
          context,
          AppRoutes.profile,
          arguments: _selected,
        );

      } else if (response.statusCode == 400) {
        print('❌ 400 Bad Request');
        await _handle400Error(response, uppercaseValue);

      } else if (response.statusCode == 401) {
        print('❌ 401 Unauthorized');
        _showErrorSnackbar('Session expired. Please login again.');

      } else {
        print('❌ Other error: ${response.statusCode}');
        _showErrorSnackbar('Error ${response.statusCode}: ${response.body.substring(0, 50)}...');
      }

    } catch (e) {
      print('❌ Exception: $e');
      _showErrorSnackbar('Network error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handle400Error(http.Response response, String sentValue) async {
    print('🔄 Handling 400 error...');

    try {
      // Parse error message
      String errorDetails = 'Bad Request';
      if (response.body.isNotEmpty) {
        try {
          final errorJson = jsonDecode(response.body);
          print('Error JSON: $errorJson');

          if (errorJson is Map) {
            if (errorJson.containsKey('message')) {
              errorDetails = errorJson['message'].toString();
            } else if (errorJson.containsKey('error')) {
              errorDetails = errorJson['error'].toString();
            } else if (errorJson.containsKey('detail')) {
              errorDetails = errorJson['detail'].toString();
            }
          }
        } catch (e) {
          errorDetails = response.body;
        }
      }

      print('Error details: $errorDetails');

      // Coba values alternatif termasuk lowercase
      await _tryAlternativeValues(sentValue, errorDetails);

    } catch (e) {
      print('Error handling failed: $e');
      _showErrorSnackbar('Validation failed. Please try again.');
    }
  }

  Future<void> _tryAlternativeValues(String originalValue, String errorMessage) async {
    print('🔄 Trying alternative values...');

    // List semua kemungkinan values dengan berbagai format
    final allPossibleValues = [
      // UPPERCASE (sudah dicoba)
      originalValue,
      // Capitalized
      _selected!,
      // lowercase
      _selected!.toLowerCase(),
      // FULL UPPERCASE
      'BEGINNER',
      'INTERMEDIATE',
      'ADVANCE',
      // Full lowercase
      'beginner',
      'intermediate',
      'advance',
      // Capitalized
      'Beginner',
      'Intermediate',
      'Advance',
      // Numeric values
      '1',
      '2',
      '3',
      // Simple values
      'low',
      'medium',
      'high',
      'Low',
      'Medium',
      'High',
      'LOW',
      'MEDIUM',
      'HIGH'
    ];

    for (var testValue in allPossibleValues) {
      print('   Testing: "$testValue"');

      try {
        // Gunakan ApiService atau langsung http
        final response = await ApiService.physicalActivity(testValue, _token!);

        if (response.statusCode == 200 || response.statusCode == 201) {
          print('   ✅ Success with: "$testValue"');

          _showSuccessSnackbar();

          await Future.delayed(const Duration(milliseconds: 300));

          Navigator.pushNamed(
            context,
            AppRoutes.profile,
            arguments: _selected,
          );
          return;
        }

      } catch (e) {
        print('   ❌ Failed: $e');
      }
    }

    // Jika semua gagal
    _showErrorSnackbar('Failed: $errorMessage');
  }

  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Activity level saved!'),
        backgroundColor: Colors.green,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Debug current selection
    if (_selected != null) {
      print('🔄 Build - Current selection: "$_selected"');
    }

    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Back Button
              GestureDetector(
                onTap: _isLoading ? null : () => Navigator.pop(context),
                child: Row(
                  children: const [
                    Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFFE2F163),
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Back',
                      style: TextStyle(
                        color: Color(0xFFE2F163),
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Title
              const Text(
                'Physical Activity Level',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),

              const Spacer(),

              // Options - GUNAKAN CAPITALIZED VALUE (akan diubah ke uppercase)
              _optionButton(value: 'Beginner', label: 'Beginner'),
              const SizedBox(height: 24),
              _optionButton(value: 'Intermediate', label: 'Intermediate'),
              const SizedBox(height: 24),
              _optionButton(value: 'Advance', label: 'Advance'),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: 180,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    color: _selected == null || _isLoading || _token == null
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 0.50, color: Colors.white),
                  ),
                  child: TextButton(
                    onPressed: _selected == null || _isLoading || _token == null
                        ? null
                        : _handleContinue,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}