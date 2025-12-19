import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class BOnBoarding extends StatelessWidget {
  const BOnBoarding({super.key});

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
                  AssetImage('assets/images/background-onboard2.png'),
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
                    'assets/icons/icon-onboard2.svg',
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


          // Button background
              Positioned(
                left: 91,
                top: 524,
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
                top: 524,
                child: Container(
                  width: 211,
                  height: 44,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.5, color: Colors.white),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),

              // =========================
              // NEXT BUTTON (CLICKABLE)
              // =========================
              Positioned(
                left: 148,
                top: 534,
                child: SizedBox(
                  width: 97,
                  height: 23,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.onboard3,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Next',
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

              // Indicator
              Positioned(
                left: 162,
                top: 474,
                child: _dot(active: true),
              ),
              Positioned(
                left: 186,
                top: 474,
                child: _dot(),
              ),
              Positioned(
                left: 210,
                top: 474,
                child: _dot(),
              ),

              // =========================
              // SKIP (TEXT CLICKABLE)
              // =========================
          Positioned(
            left: 310, // geser dikit ke kiri karena ada icon
            top: 65,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.login,
                );
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

// =========================
// DOT INDICATOR WIDGET
// =========================
Widget _dot({bool active = false}) {
  return Container(
    width: 20,
    height: 13,
    decoration: ShapeDecoration(
      color: active ? Colors.white : const Color(0xFF588D6E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
