import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';
import '../routes/app_routes.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  String? _selected; // 'lose' | 'gain' | 'muscle' | 'shape' | 'others'
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
    setState(() {
      _token = token;
    });
  }

  Future<void> _sendGoalToBackend() async {
    if (_selected == null || _token == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Kirim goal ke backend
      print('🚀 Sending goal to API: "$_selected"');
      final response = await ApiService.goal(_selected!, _token!);

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Goal saved successfully!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Goal saved!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 800),
          ),
        );
        await Future.delayed(const Duration(milliseconds: 300));
        // Navigate to home
        Navigator.pushNamed(
          context,
          AppRoutes.home,
          arguments: _selected,
        );

      } else {
        print('❌ Failed to save goal: ${response.statusCode}');
        _showErrorSnackbar('Failed to save goal. Please try again.');
      }
    } catch (e) {
      print('❌ Exception: $e');
      _showErrorSnackbar('Network error. Please check your connection.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _goalItem({
    required String value,
    required String label,
  }) {
    final bool isSelected = _selected == value;

    return GestureDetector(
      onTap: _isLoading ? null : () => setState(() => _selected = value),
      child: Opacity(
        opacity: _isLoading ? 0.6 : 1.0,
        child: Container(
          width: double.infinity,
          height: 54,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF34C759) : Colors.white,
            borderRadius: BorderRadius.circular(36),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFF2F2F7) : const Color(0xFF232222),
              fontSize: 18,
              fontFamily: 'League Spartan',
              fontWeight: FontWeight.w400,
              height: 0.78,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Back
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
                'What Is Your Goal?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),

              const SizedBox(height: 40),

              // Goals (responsive)
              _goalItem(value: 'lose', label: 'lose weight'),
              const SizedBox(height: 22),
              _goalItem(value: 'gain', label: 'Gain weight'),
              const SizedBox(height: 22),
              _goalItem(value: 'muscle', label: 'Muscle Mass Gain'),
              const SizedBox(height: 22),
              _goalItem(value: 'shape', label: 'shape body'),
              const SizedBox(height: 22),
              _goalItem(value: 'others', label: 'Others'),

              const Spacer(),

              // Continue
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
                        : _sendGoalToBackend,
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