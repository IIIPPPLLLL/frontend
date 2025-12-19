import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class AHowOld extends StatefulWidget {
  const AHowOld({super.key});

  @override
  State<AHowOld> createState() => _AHowOldState();
}

class _AHowOldState extends State<AHowOld> {
  // 🔥 initial age (center)
  int _age = 28;

  // range biar aman (ubah kalau mau)
  static const int _minAge = 1;
  static const int _maxAge = 100;

  void _setAge(int value) {
    final v = value.clamp(_minAge, _maxAge);
    setState(() => _age = v);
  }

  @override
  Widget build(BuildContext context) {
    // angka sekitar (kiri/kanan)
    final int a1 = (_age - 2).clamp(_minAge, _maxAge);
    final int a2 = (_age - 1).clamp(_minAge, _maxAge);
    final int a3 = _age;
    final int a4 = (_age + 1).clamp(_minAge, _maxAge);
    final int a5 = (_age + 2).clamp(_minAge, _maxAge);

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
                'How Old Are You?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 70),

              // Big Age
              Text(
                '$_age',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 70),

              // ✅ Swipe bar (geser kiri/kanan)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // swipe kanan -> age turun, swipe kiri -> age naik (feel natural bisa dibalik)
                  if (details.delta.dx > 6) {
                    _setAge(_age - 1);
                  } else if (details.delta.dx < -6) {
                    _setAge(_age + 1);
                  }
                },
                child: Container(
                  height: 99,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF588D6E),
                  ),
                  child: Stack(
                    children: [
                      // divider kiri & kanan (mirip figma)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: LayoutBuilder(
                          builder: (context, c) {
                            final w = c.maxWidth;
                            final center = w / 2;

                            return Stack(
                              children: [
                                Positioned(
                                  left: center - 59, // ~118/2
                                  top: -10,
                                  bottom: -10,
                                  child: Container(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                Positioned(
                                  left: center + 59,
                                  top: -10,
                                  bottom: -10,
                                  child: Container(
                                    width: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // numbers row
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Opacity(
                              opacity: 0.45,
                              child: Text(
                                '$a1',
                                style: const TextStyle(
                                  color: Color(0xFF232222),
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 0.65,
                              child: Text(
                                '$a2',
                                style: const TextStyle(
                                  color: Color(0xFF232222),
                                  fontSize: 35,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Text(
                              '$a3',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Opacity(
                              opacity: 0.65,
                              child: Text(
                                '$a4',
                                style: const TextStyle(
                                  color: Color(0xFF232222),
                                  fontSize: 35,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Opacity(
                              opacity: 0.45,
                              child: Text(
                                '$a5',
                                style: const TextStyle(
                                  color: Color(0xFF232222),
                                  fontSize: 25,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

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
                    onPressed: () {
                      // kalau mau kirim age ke page berikut:
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.gender,
                        arguments: _age,
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
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
