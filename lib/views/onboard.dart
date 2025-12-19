import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AOnBoarding extends StatelessWidget {
  const AOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFF232222),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image:
                  AssetImage('assets/images/background-onboard.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Overlay hitam transparan
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.4),
            ),
          ),

          // Text "Welcome to"
          Align(
            alignment: const Alignment(0, -0.18),
            child: Text(
              'Welcome to',
              style: TextStyle(
                color: const Color(0xFFE2F163),
                fontSize: 25.47,
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.none,
                height: 1.08,
              ),
            ),
          ),

          // Logo
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 131,
              height: 115,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image:
                  AssetImage('assets/images/logo-onboard.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Text "HealtyLife"
          Align(
            alignment: const Alignment(0, 0.25),
            child: Text(
              'HealtyLife',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFE2F163),
                fontSize: 54.04,
                fontStyle: FontStyle.italic,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.none,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.7),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
            ),
          ),

          // ======================
          // BUTTON GET STARTED
          // ======================
          Align(
            alignment: const Alignment(0, 0.45),
            child: SizedBox(
              width: 220,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.onboard2,
                  );
                  debugPrint('Get Started clicked');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2F163),
                  foregroundColor: const Color(0xFF232222),
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
