import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';


class DOnBoarding extends StatelessWidget {
  const DOnBoarding({super.key});

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
                  AssetImage('assets/images/background-onboard4.png'),
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

          // Title Text
          Positioned(
            left: 42,
            top: 355,
            child: SizedBox(
              width: 309,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/icons/icon-onboard4.svg',
                    width: 48,
                    height: 48,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFFE2F163),
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Start your journey towards a more active lifestyle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 91,
            top: 524,
            child: Container(
              width: 211,
              height: 44,
              decoration: ShapeDecoration(
                color: Colors.white.withValues(alpha: 0.09),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            left: 91,
            top: 524,
            child: Container(
              width: 211,
              height: 44,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 0.50, color: Colors.white),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
          Positioned(
            left: 148,
            top: 534,
            child: SizedBox(
              width: 97,
              height: 23,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.login,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                ),
                child: const Text(
                  'Get Started',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 186,
            top: 474,
            child: Container(
              width: 20,
              height: 13,
              decoration: ShapeDecoration(
                color: const Color(0xFF588D6E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            left: 210,
            top: 474,
            child: Container(
              width: 20,
              height: 13,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            left: 162,
            top: 474,
            child: Container(
              width: 20,
              height: 13,
              decoration: ShapeDecoration(
                color: const Color(0xFF588D6E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Positioned(
            left: 165,
            top: 354,
            child: Container(
              width: 63.50,
              height: 42.73,
              child: Stack(),
            ),
          ),
        ],
      ),
    );
  }
}