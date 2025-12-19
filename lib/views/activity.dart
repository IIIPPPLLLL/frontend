import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class ActivityLevel extends StatefulWidget {
  const ActivityLevel({super.key});

  @override
  State<ActivityLevel> createState() => _ActivityLevelState();
}

class _ActivityLevelState extends State<ActivityLevel> {
  String? _selected; // 'beginner' | 'intermediate' | 'advance'

  Widget _optionButton({
    required String value,
    required String label,
  }) {
    final bool isSelected = _selected == value;

    return GestureDetector(
      onTap: () => setState(() => _selected = value),
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

              // Options (fix ke HP, responsif)
              _optionButton(value: 'beginner', label: 'Beginner'),
              const SizedBox(height: 24),
              _optionButton(value: 'intermediate', label: 'Intermediate'),
              const SizedBox(height: 24),
              _optionButton(value: 'advance', label: 'Advance'),

              const Spacer(),

              // Continue button
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
                        AppRoutes.profile,
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
