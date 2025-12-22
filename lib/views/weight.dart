import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // ✅ manual input (tap to type)
  Future<void> _showManualWeightInput() async {
    final bool isKgNow = _isKg;

    // range display tergantung unit
    final int minDisplay = isKgNow ? _minKg : _toLb(_minKg);
    final int maxDisplay = isKgNow ? _maxKg : _toLb(_maxKg);

    final int currentDisplay = isKgNow ? _weightKg : _weightLb;

    final controller = TextEditingController(text: currentDisplay.toString());
    String? errorText;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            void validate(String v) {
              if (v.trim().isEmpty) {
                setLocalState(() => errorText = "Weight can't be empty");
                return;
              }
              final parsed = int.tryParse(v);
              if (parsed == null) {
                setLocalState(() => errorText = "Please enter a valid number");
                return;
              }
              if (parsed < minDisplay || parsed > maxDisplay) {
                setLocalState(
                      () => errorText =
                  "Weight must be between $minDisplay and $maxDisplay ${isKgNow ? 'kg' : 'lb'}",
                );
                return;
              }
              setLocalState(() => errorText = null);
            }

            void applyValue() {
              final v = controller.text.trim();
              final parsed = int.tryParse(v);

              if (v.isEmpty) {
                setLocalState(() => errorText = "Weight can't be empty");
                return;
              }
              if (parsed == null) {
                setLocalState(() => errorText = "Please enter a valid number");
                return;
              }
              if (parsed < minDisplay || parsed > maxDisplay) {
                setLocalState(
                      () => errorText =
                  "Weight must be between $minDisplay and $maxDisplay ${isKgNow ? 'kg' : 'lb'}",
                );
                return;
              }

              if (isKgNow) {
                _setKg(parsed);
              } else {
                // input LB -> convert ke KG (source of truth tetap kg)
                final int kg = _lbToKg(parsed);
                _setKg(kg);
              }

              Navigator.pop(ctx);
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF232222),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Text(
                "Enter your weight (${isKgNow ? 'kg' : 'lb'})",
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              content: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  hintText: isKgNow ? "e.g. 75" : "e.g. 165",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  errorText: errorText,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.35)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE2F163), width: 1.2),
                  ),
                ),
                onChanged: validate,
                onSubmitted: (_) => applyValue(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  ),
                ),
                TextButton(
                  onPressed: applyValue,
                  child: const Text(
                    "OK",
                    style: TextStyle(color: Color(0xFFE2F163), fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
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
                        child: const Center(
                          child: Text(
                            'KG',
                            style: TextStyle(
                              color: Color(0xFF232222),
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
                        child: const Center(
                          child: Text(
                            'LB',
                            style: TextStyle(
                              color: Color(0xFF232222),
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

              // ✅ Big number bawah (ikut KG/LB) + tap to type
              GestureDetector(
                onTap: _showManualWeightInput,
                child: Column(
                  children: [
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
                    const SizedBox(height: 6),
                    Text(
                      'Tap to type',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.55),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
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
                        AppRoutes.activity,
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

  // ✅ lb -> kg converter
  int _lbToKg(int lb) => (lb / 2.2046226218).round();
}
