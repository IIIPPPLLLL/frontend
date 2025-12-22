import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';
import '../service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ALogIn extends StatefulWidget {
  const ALogIn({super.key});

  @override
  State<ALogIn> createState() => _ALogInState();
}

class _ALogInState extends State<ALogIn> {
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> handleLogin() async {
    final identifier = identifierController.text.trim();
    final password = passwordController.text.trim();

    if (identifier.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan password wajib diisi')),
      );
      return;
    }

    try {
      final response = await ApiService.login(identifier, password);

      // ✅ CUKUP CEK HTTP STATUS
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);


        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data['message'] ?? 'Login berhasil',
            ),
          ),
        );
        final token = data['data']['token'] ??
            data['token'] ??
            data['access_token'] ??
            data['accessToken'];

        if (token != null) {
          // Simpan token ke SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);

          // Navigasi ke gender page
          Navigator.pushNamed(context, AppRoutes.gender);
        } else {
          // Token tidak ditemukan di response
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Token not found in response'),
              backgroundColor: Colors.red,
            ),
          );
        }
        // ✅ PINDAH HALAMAN
        Navigator.pushReplacementNamed(context, AppRoutes.setup);

      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username / password salah'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server error (${response.statusCode})'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }


  @override
  void dispose() {
    identifierController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),

                // Back Button
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Color(0xFFE2F163),
                      size: 20,
                    ),
                  ),
                ),

                // Title
                const Text(
                  'Log In',
                  style: TextStyle(
                    color: Color(0xFFE2F163),
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 40),

                // Welcome Text
                const Text(
                  'Welcome to HealthyLife',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 20),

                // Description
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w300,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 40),

                // Username
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: identifierController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          hintText: 'example',
                          hintStyle: TextStyle(
                            color: const Color(0xFF232222).withOpacity(0.7),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF232222),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // Password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white),
                      ),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 12,
                          ),
                          hintText: '*************',
                          hintStyle: TextStyle(
                            color: const Color(0xFF232222).withOpacity(0.7),
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3.68,
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF232222),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 3.68,
                        ),
                      ),
                    ),
                  ],
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF232222),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Login Button
                SizedBox(
                  width: 200,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(200),
                        side: const BorderSide(
                          width: 1.50,
                          color: Colors.white,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: const Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Don\'t have an account? ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.signup,
                              );
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Color(0xFFE2F163),
                                fontSize: 14,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
