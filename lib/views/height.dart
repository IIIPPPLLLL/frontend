import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Height extends StatefulWidget {
  const Height({super.key});

  @override
  State<Height> createState() => _HeightState();
}

class _HeightState extends State<Height> {
  int _height = 165;

  static const int _minH = 120;
  static const int _maxH = 220;

  void _setHeight(int value) {
    setState(() {
      _height = value.clamp(_minH, _maxH);
    });
  }

  @override
  Widget build(BuildContext context) {
    final int h1 = (_height + 10).clamp(_minH, _maxH); // atas jauh
    final int h2 = (_height + 5).clamp(_minH, _maxH);  // atas dekat
    final int h3 = _height;                            // tengah
    final int h4 = (_height - 5).clamp(_minH, _maxH);  // bawah dekat
    final int h5 = (_height - 10).clamp(_minH, _maxH); // bawah jauh

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
                'What Is Your height?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 50),

              // Big height + unit
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_height',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Opacity(
                    opacity: 0.65,
                    child: Text(
                      'cm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // ✅ Vertical drag area (tarik atas/bawah)
              GestureDetector(
                onVerticalDragUpdate: (details) {
                  // tarik ke atas => angka naik
                  if (details.delta.dy < -6) {
                    _setHeight(_height + 1);
                  }
                  // tarik ke bawah => angka turun
                  else if (details.delta.dy > 6) {
                    _setHeight(_height - 1);
                  }
                },
                child: SizedBox(
                  height: 320,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Left numbers
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.45,
                            child: Text(
                              '$h1',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Opacity(
                            opacity: 0.65,
                            child: Text(
                              '$h2',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            '$h3',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Opacity(
                            opacity: 0.65,
                            child: Text(
                              '$h4',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 35,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Opacity(
                            opacity: 0.45,
                            child: Text(
                              '$h5',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(width: 18),

                      // Middle green "ruler"
                      Container(
                        width: 70,
                        height: 280,
                        decoration: BoxDecoration(
                          color: const Color(0xFF588D6E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Stack(
                          children: [
                            // ticks (simple)
                            Positioned.fill(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 18,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(12, (i) {
                                    final bool longTick = i % 3 == 0;
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width: longTick ? 34 : 22,
                                        height: 2,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ),

                            // highlight line (center)
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                width: 56,
                                height: 0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 3,
                                    color: const Color(0xFFE2F163),
                                  ),
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

              // Continue
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
                      Navigator.pushNamed(
                        context,
                        AppRoutes.height,
                        arguments: _height,
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

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
