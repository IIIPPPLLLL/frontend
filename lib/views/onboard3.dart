import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class COnBoarding extends StatelessWidget {
  const COnBoarding({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 393,
          height: 853,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 393,
                  height: 852,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/background-onboard3.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 42,
                top: 406,
                child: SizedBox(
                  width: 309,
                  child: Text(
                    'Find nutrition tips that fit your lifestyle',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 91,
                top: 525,
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
                top: 525,
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
                top: 535,
                child: SizedBox(
                  width: 97,
                  height: 23,
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
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
                left: 176,
                top: 354,
                child: SizedBox(
                  width: 40.51,
                  height: 42.70,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 364,
                top: 79,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                  width: 6,
                  height: 11,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 315,
                top: 66,
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: 18,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}