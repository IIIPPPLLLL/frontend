import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class COnBoarding extends StatelessWidget {
  const COnBoarding({super.key});

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
                  AssetImage('assets/images/background-onboard3.png'),
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

            // Title + Icon
            Positioned(
              left: 42,
              top: 355,
              child: SizedBox(
                width: 309,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/apple.svg',
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

            // Button background (blur-ish look)
            Positioned(
              left: 91,
              top: 525,
              child: Container(
                width: 211,
                height: 44,
                decoration: ShapeDecoration(
                  color: Colors.white.withOpacity(0.09),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),

            // Button border
            Positioned(
              left: 91,
              top: 525,
              child: Container(
                width: 211,
                height: 44,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 0.50, color: Colors.white),
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
            ),

            // Next button (tap area)
            Positioned(
              left: 91,
              top: 525,
              child: SizedBox(
                width: 211,
                height: 44,
                child: TextButton(
                  onPressed: () {
                    // ganti ini ke route tujuan kamu (misal login)
                    Navigator.pushNamed(context, AppRoutes.onboard4);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            // Dots indicator
            Positioned(
              left: 162,
              top: 475,
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
              left: 186,
              top: 475,
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
              left: 210,
              top: 475,
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

            // Skip + arrow
            Positioned(
              left: 310,
              top: 65,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.login);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFFE2F163),
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      'assets/icons/icon-arrow-onboard2.svg',
                      width: 16,
                      height: 16,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFE2F163),
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
