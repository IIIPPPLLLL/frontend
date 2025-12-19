import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class GenderA extends StatefulWidget {
  const GenderA({super.key});

  @override
  State<GenderA> createState() => _GenderAState();
}

class _GenderAState extends State<GenderA> {
  String? selectedGender; // 'male' | 'female'

  @override
  Widget build(BuildContext context) {
    final bool isMaleSelected = selectedGender == 'male';
    final bool isFemaleSelected = selectedGender == 'female';

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
                onTap: () => setState(() => selectedGender = 'male'),
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

              const SizedBox(height: 30),

              // Female
              GestureDetector(
                onTap: () => setState(() => selectedGender = 'female'),
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

              const Spacer(),

              // Continue Button
              SizedBox(
                width: 180,
                height: 44,
                child: Container(
                  decoration: BoxDecoration(
                    color: selectedGender == null
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(
                      width: 0.50,
                      color: Colors.white,
                    ),
                  ),
                  child: TextButton(
                    onPressed: selectedGender == null
                        ? null
                        : () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.old,
                        arguments: selectedGender,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
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
