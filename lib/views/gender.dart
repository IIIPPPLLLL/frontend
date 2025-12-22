import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';
import '../service/api_service.dart';

class GenderA extends StatefulWidget {
  const GenderA({super.key});

  @override
  State<GenderA> createState() => _GenderAState();
}

class _GenderAState extends State<GenderA> {
  String? selectedGender; // 'male' | 'female'
  bool _isLoading = false;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    setState(() {
      _token = token;
    });
  }

  Future<void> _updateGender() async {
    if (selectedGender == null || _token == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Kirim gender dengan token
      final response = await ApiService.gender(selectedGender!, _token!);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Jika berhasil, navigasi ke halaman berikutnya
        Navigator.pushNamed(
          context,
          AppRoutes.old,
          arguments: selectedGender,
        );
      } else if (response.statusCode == 401) {
        // Token expired atau tidak valid
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        // Bisa navigasi ke login page
        // Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connection error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMaleSelected = selectedGender == 'male';
    final bool isFemaleSelected = selectedGender == 'female';

    // Tampilkan loading jika token belum diambil
    if (_token == null && !_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF232222),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color(0xFFE2F163),
          ),
        ),
      );
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
                "What's Your Gender",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 30),

              // Male
              GestureDetector(
                onTap: _isLoading ? null : () => setState(() => selectedGender = 'male'),
                child: Opacity(
                  opacity: _isLoading ? 0.6 : 1.0,
                  child: Column(
                    children: [
                      Container(
                        width: 163,
                        height: 163,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isMaleSelected
                              ? const Color(0xFF2EC4FF).withOpacity(0.80)
                              : Colors.white.withOpacity(0.09),
                          border: Border.all(
                            width: 2,
                            color: isMaleSelected
                                ? const Color(0xFF2EC4FF)
                                : Colors.white,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.male,
                            size: 70,
                            color: isMaleSelected
                                ? const Color(0xFFE2F163)
                                : Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Male',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Female
              GestureDetector(
                onTap: _isLoading ? null : () => setState(() => selectedGender = 'female'),
                child: Opacity(
                  opacity: _isLoading ? 0.6 : 1.0,
                  child: Column(
                    children: [
                      Container(
                        width: 163,
                        height: 163,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isFemaleSelected
                              ? const Color(0xFFFF5FA2)
                              : Colors.white.withOpacity(0.09),
                          border: Border.all(
                            width: 2,
                            color: isFemaleSelected
                                ? const Color(0xFFFF5FA2)
                                : Colors.white,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.female,
                            size: 70,
                            color: isFemaleSelected ? Colors.white : Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Female',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              SizedBox(
                width: 180,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedGender == null || _isLoading || _token == null
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 0.50,
                      color: Colors.white,
                    ),
                  ),
                  child: TextButton(
                    onPressed: selectedGender == null || _isLoading || _token == null
                        ? null
                        : _updateGender,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
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
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}