import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Goal extends StatefulWidget {
  const Goal({super.key});

  @override
  State<Goal> createState() => _GoalState();
}

class _GoalState extends State<Goal> {
  String? _selected; // 'lose' | 'gain' | 'muscle' | 'shape' | 'others'

  Widget _goalItem({
    required String value,
    required String label,
  }) {
    final bool isSelected = _selected == value;

    return GestureDetector(
      onTap: () => setState(() => _selected = value),
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
                    color: Colors.white.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(width: 0.50, color: Colors.white),
                  ),
                  child: TextButton(
                    onPressed: _selected == null
                        ? null
                        : () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.home,
                        arguments: _selected,
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
