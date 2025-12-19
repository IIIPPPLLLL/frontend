import 'dart:async';
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

class AnimatedSplashScreen extends StatefulWidget {
  const AnimatedSplashScreen({super.key});

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    // ⏱ PINDAH KE ONBOARD 1
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.onboard1,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: const Scaffold(
        body: ALaunch(),
      ),
    );
  }
}

class ALaunch extends StatelessWidget {
  const ALaunch({super.key});

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
          // Menggunakan Align untuk posisi persentase
          Align(
            alignment: const Alignment(0, -0.14), // Logo position
            child: SizedBox(
              width: 131,
              height: 115,
              child: Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/logo-launch.png'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
              ),
            ),
          ),

          Align(
            alignment: const Alignment(0, 0.14), // Text position
            child: SizedBox(
              width: 276.92,
              child: Text(
                'HealtyLife',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFE2F163),
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}