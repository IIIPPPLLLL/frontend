import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.onboard2,
            );
          },
          child: const Text('Get Started'),
        ),
      ),
    );
  }
}

class BOnBoarding extends StatelessWidget {
  const BOnBoarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 839,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: const Color(0xFF232222),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: -93,
                top: -304,
                child: Container(
                  width: 675,
                  height: 1200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://placehold.co/675x1200"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 364,
                top: 78,
                child: Container(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                  width: 6,
                  height: 11,
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 42,
                top: 405,
                child: SizedBox(
                  width: 309,
                  child: Text(
                    'Start your journey towards a more active lifestyle',
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
                    color: const Color(0xFF588D6E),
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
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 177,
                top: 353,
                child: Container(
                  width: 38.35,
                  height: 43.32,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Stack(),
                ),
              ),
              Positioned(
                left: 315,
                top: 65,
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