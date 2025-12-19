import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Weight extends StatefulWidget {
  const Weight({super.key});

  @override
  State<Weight> createState() => _WeightState();
}

class _WeightState extends State<Weight> {
  // ✅ state
  bool _isKg = true; // true = KG, false = LB
  int _weightKg = 75;

  // range
  static const int _minKg = 30;
  static const int _maxKg = 200;

  // helper convert
  int get _weightLb => (_weightKg * 2.2046226218).round();

  void _setKg(int v) {
    setState(() {
      _weightKg = v.clamp(_minKg, _maxKg);
    });
  }

  void _switchToKg() {
    setState(() => _isKg = true);
  }

  void _switchToLb() {
    setState(() => _isKg = false);
  }

  // swipe horizontal (penggaris)
  void _onRulerDrag(DragUpdateDetails details) {
    // geser kiri -> naik, geser kanan -> turun (feel natural bisa kamu balik)
    if (details.delta.dx < -6) {
      _setKg(_weightKg + 1);
    } else if (details.delta.dx > 6) {
      _setKg(_weightKg - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    // angka sekitar buat row atas (73 74 75 76 77)
    final int w1 = (_weightKg - 2).clamp(_minKg, _maxKg);
    final int w2 = (_weightKg - 1).clamp(_minKg, _maxKg);
    final int w3 = _weightKg;
    final int w4 = (_weightKg + 1).clamp(_minKg, _maxKg);
    final int w5 = (_weightKg + 2).clamp(_minKg, _maxKg);

    final int displayValue = _isKg ? _weightKg : _weightLb;
    final String unit = _isKg ? 'kg' : 'lb';

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
                'What Is Your Weight?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 30),

              // ✅ Toggle KG | LB (bisa dipencet)
              Container(
                width: double.infinity,
                height: 58,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2F163),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: _switchToKg,
                        child: Center(
                          child: Text(
                            'KG',
                            style: TextStyle(
                              color: const Color(0xFF232222),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 3,
                      height: 40,
                      color: const Color(0xFF232222),
                    ),
                    Expanded(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: _switchToLb,
                        child: Center(
                          child: Text(
                            'LB',
                            style: TextStyle(
                              color: const Color(0xFF232222),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ✅ Ruler + numbers (geser kanan kiri)
              GestureDetector(
                onHorizontalDragUpdate: _onRulerDrag,
                child: Column(
                  children: [
                    // numbers row (73 74 75 76 77)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Opacity(
                          opacity: 0.45,
                          child: Text(
                            '${_isKg ? w1 : (_toLb(w1))}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.65,
                          child: Text(
                            '${_isKg ? w2 : (_toLb(w2))}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          '${_isKg ? w3 : (_toLb(w3))}',
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
                            '${_isKg ? w4 : (_toLb(w4))}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Opacity(
                          opacity: 0.45,
                          child: Text(
                            '${_isKg ? w5 : (_toLb(w5))}',
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

                    const SizedBox(height: 10),

                    // ruler bar
                    Container(
                      height: 87,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFF588D6E),
                      ),
                      child: Stack(
                        children: [
                          // ticks
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(19, (i) {
                                  final bool longTick = i % 3 == 0;
                                  return Container(
                                    width: 2,
                                    height: longTick ? 46 : 24,
                                    color: Colors.white.withOpacity(0.9),
                                  );
                                }),
                              ),
                            ),
                          ),

                          // center highlight
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 3,
                              height: 56,
                              color: const Color(0xFFE2F163),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // ✅ Big number bawah (ikut KG/LB)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$displayValue',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 64,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Opacity(
                    opacity: 0.65,
                    child: Text(
                      unit,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Continue Button
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
                        AppRoutes.weight,
                        arguments: {
                          'unit': unit,
                          'weightKg': _weightKg,
                          'weightLb': _weightLb,
                        },
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

  int _toLb(int kg) => (kg * 2.2046226218).round();
}
