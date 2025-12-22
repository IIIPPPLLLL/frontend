import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _fullNameC = TextEditingController();
  final _nickNameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();

  @override
  void dispose() {
    _fullNameC.dispose();
    _nickNameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    super.dispose();
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFF588D6E),
        fontSize: 18,
        fontFamily: 'League Spartan',
        fontWeight: FontWeight.w500,
        decoration: TextDecoration.none,
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(width: 1, color: const Color(0xFFE9F6FE)),
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF391713),
          fontSize: 20,
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isCollapsed: true,
          hintText: hint,
          hintStyle: const TextStyle(
            color: Color(0xFF391713),
            fontSize: 20,
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.w400,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Back
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                  'Fill Your Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Set up your profile and let’s get started. ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w300,
                    height: 1.2,
                    decoration: TextDecoration.none,
                  ),
                ),

                const SizedBox(height: 28),

                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 125,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(200),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/jokowi.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: 27,
                      height: 27,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE2F163),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 16,
                        color: Color(0xFF232222),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // Form fields
                Align(alignment: Alignment.centerLeft, child: _label('Full name')),
                const SizedBox(height: 6),
                _field(controller: _fullNameC, hint: 'Fill your Full name'),
                const SizedBox(height: 14),

                Align(alignment: Alignment.centerLeft, child: _label('Nickname')),
                const SizedBox(height: 6),
                _field(controller: _nickNameC, hint: 'Fill your Nickname'),
                const SizedBox(height: 14),

                Align(alignment: Alignment.centerLeft, child: _label('Email')),
                const SizedBox(height: 6),
                _field(
                  controller: _emailC,
                  hint: 'max@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),

                Align(alignment: Alignment.centerLeft, child: _label('Mobile Number')),
                const SizedBox(height: 6),
                _field(
                  controller: _phoneC,
                  hint: '+62 000 000 00',
                  keyboardType: TextInputType.phone,
                ),

                const SizedBox(height: 28),

                // Continue Button
                SizedBox(
                  width: 180,
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 0.50, color: Colors.white),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // contoh passing data
                        Navigator.pushNamed(
                          context,
                          AppRoutes.goal,
                          arguments: {
                            'fullName': _fullNameC.text.trim(),
                            'nickName': _nickNameC.text.trim(),
                            'email': _emailC.text.trim(),
                            'phone': _phoneC.text.trim(),
                          },
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
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
      ),
    );
  }
}
