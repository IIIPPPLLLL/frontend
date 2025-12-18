import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500, // Maksimal width untuk tablet
              maxHeight: 900, // Maksimal height
            ),
            child: const AspectRatio(
              aspectRatio: 393/852, // Original aspect ratio dari design (393x852)
              child: ALaunch(),
            ),
          ),
        ),
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
        border: Border.all(width: 1, color: Colors.white),
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