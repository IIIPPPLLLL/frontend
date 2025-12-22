import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class ASetUp extends StatelessWidget {
  const ASetUp({super.key});
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
              Positioned(
                left: 0,
                top: -27,
                child: Opacity(
                  opacity: 0.74,
                  child: Container(
                    width: 426,
                    height: 489,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/background-setup.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                top: 630,
                child: Container(
                  width: 393,
                  height: 116,
                  decoration: BoxDecoration(color: const Color(0xFF588D6E)),
                ),
              ),
              Positioned(
                left: 35,
                top: 665,
                child: SizedBox(
                  width: 323,
                  child: Text(
                    "Consistency is what turns effort into results."
                    " Keep showing up. Your future self will thank you." ,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w300,
                      height: 1,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 107,
                top: 800,
                child: Container(
                  width: 178.56,
                  height: 44,
                  decoration: ShapeDecoration(
                    color: Colors.white.withValues(alpha: 0.09),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 107,
                top: 800,
                child: Container(
                  width: 178.56,
                  height: 44,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Colors.white),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 107,
                top: 800,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.gender);
                  },
                  child: Container(
                    width: 178.56,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Next',
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

              Positioned(
                left: 32,
                top: 495,
                child: SizedBox(
                  width: 328,
                  height: 150,
                  child: Text(
                    "Consistency Is \nthe Key To progress.\nDon't Give Up!",
                  textAlign: TextAlign.center,
                    style: TextStyle(
                      color: const Color(0xFFF8FFFA),
                      fontSize: 30,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1.20,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Positioned(
                left: 35,
                top: 71,
                child: Container(width: 6, height: 11, child: Stack()),
              ),
            ],
          ),
        );
  }
}