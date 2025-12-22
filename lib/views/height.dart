import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../routes/app_routes.dart';
import '../service/api_service.dart';

class Height extends StatefulWidget {
  const Height({super.key});

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  int _height = 165;
  bool _isLoading = false;
  String? _token;

  static const int _minH = 120;
  static const int _maxH = 220;

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print('🔐 Token loaded for height: ${token != null ? "Yes" : "No"}');
    setState(() {
      _token = token;
    });
  }

  void _setHeight(int value) {
    setState(() {
      _height = value.clamp(_minH, _maxH);
    });
  }

  Future<void> _updateHeight() async {
    if (_token == null) {
      _showErrorSnackbar('Session expired. Please login again.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      print('🚀 Sending height to API: $_height cm');
      print('🔑 Token: ${_token!.substring(0, _token!.length > 20 ? 20 : _token!.length)}...');

      final response = await ApiService.height(_height, _token!);

      print('📡 Height API Response: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Height updated successfully');

        // Tampilkan success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Height saved!'),
            backgroundColor: Colors.green,
            duration: Duration(milliseconds: 800),
          ),
        );

        // Tunggu sebentar sebelum navigasi
        await Future.delayed(const Duration(milliseconds: 300));

        // Navigasi ke halaman berikutnya
        Navigator.pushNamed(
          context,
          AppRoutes.weight,
          arguments: _height,
        );

      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - Token invalid/expired');
        _showErrorSnackbar('Session expired. Please login again.');

        // Clear token
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        // Navigator.pushReplacementNamed(context, AppRoutes.login);

      } else if (response.statusCode == 400) {
        print('❌ Bad Request');
        final errorMsg = _parseError(response.body);
        _showErrorSnackbar('Validation error: $errorMsg');

      } else {
        print('❌ Server error: ${response.statusCode}');
        final errorMsg = _parseError(response.body);
        _showErrorSnackbar('Error: $errorMsg (${response.statusCode})');
      }
    } catch (e) {
      print('❌ Exception: $e');
      _showErrorSnackbar('Network error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _parseError(String body) {
    try {
      if (body.isEmpty) return 'Empty response from server';
      final json = jsonDecode(body);
      return json['message'] ??
          json['error'] ??
          json['detail'] ??
          'Unknown error';
    } catch (e) {
      return body.isNotEmpty && body.length < 100 ? body : 'Unknown error';
    }
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

  @override
  Widget build(BuildContext context) {
    final int h1 = (_height + 10).clamp(_minH, _maxH); // atas jauh
    final int h2 = (_height + 5).clamp(_minH, _maxH);  // atas dekat
    final int h3 = _height;                            // tengah
    final int h4 = (_height - 5).clamp(_minH, _maxH);  // bawah dekat
    final int h5 = (_height - 10).clamp(_minH, _maxH); // bawah jauh

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
                'What Is Your Height?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 50),

              // Big height + unit
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_height',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Opacity(
                    opacity: 0.65,
                    child: Text(
                      'cm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ✅ Vertical drag area (tarik atas/bawah)
              GestureDetector(
                onVerticalDragUpdate: _isLoading ? null : (details) {
                  // tarik ke atas => angka naik
                  if (details.delta.dy < -6) {
                    _setHeight(_height + 1);
                  }
                  // tarik ke bawah => angka turun
                  else if (details.delta.dy > 6) {
                    _setHeight(_height - 1);
                  }
                },
                child: Opacity(
                  opacity: _isLoading ? 0.6 : 1.0,
                  child: SizedBox(
                    height: 320,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Left numbers
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: 0.45,
                              child: Text(
                                '$h1',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Opacity(
                              opacity: 0.65,
                              child: Text(
                                '$h2',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              '$h3',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 18),
                            Opacity(
                              opacity: 0.65,
                              child: Text(
                                '$h4',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Opacity(
                              opacity: 0.45,
                              child: Text(
                                '$h5',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 18),

                        // Middle green "ruler"
                        Container(
                          width: 70,
                          height: 280,
                          decoration: BoxDecoration(
                            color: const Color(0xFF588D6E),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              // ticks (simple)
                              Positioned.fill(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 18,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: List.generate(12, (i) {
                                      final bool longTick = i % 3 == 0;
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: longTick ? 34 : 22,
                                          height: 2,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ),

                              // highlight line (center)
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  width: 56,
                                  height: 0,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 3,
                                      color: const Color(0xFFE2F163),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // Status info
              if (_token == null && !_isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Loading session...',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 14,
                    ),
                  ),
                ),

              // Loading indicator jika token null
              if (_token == null && _isLoading)
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.orange,
                    ),
                  ),
                ),

              // Continue button
              SizedBox(
                width: 180,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    color: _isLoading || _token == null
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 0.50, color: Colors.white),
                  ),
                  child: TextButton(
                    onPressed: _isLoading || _token == null
                        ? null
                        : _updateHeight,
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