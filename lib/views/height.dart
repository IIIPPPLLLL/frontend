import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _showManualHeightInput() async {
    final controller = TextEditingController(text: _height.toString());
    String? errorText;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            void validate(String v) {
              if (v.trim().isEmpty) {
                setLocalState(() => errorText = "Height can't be empty");
                return;
              }
              final parsed = int.tryParse(v);
              if (parsed == null) {
                setLocalState(() => errorText = "Please enter a valid number");
                return;
              }
              if (parsed < _minH || parsed > _maxH) {
                setLocalState(() => errorText = "Height must be between $_minH and $_maxH");
                return;
              }
              setLocalState(() => errorText = null);
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF232222),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                "Enter your height (cm)",
                style: TextStyle(
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
                  hintText: "e.g. 165",
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
                onSubmitted: (v) {
                  validate(v);
                  if (errorText == null) {
                    _setHeight(int.parse(v));
                    Navigator.pop(ctx);
                  }
                },
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
                  onPressed: () {
                    final v = controller.text.trim();
                    final parsed = int.tryParse(v);

                    if (v.isEmpty) {
                      setLocalState(() => errorText = "Height can't be empty");
                      return;
                    }
                    if (parsed == null) {
                      setLocalState(() => errorText = "Please enter a valid number");
                      return;
                    }
                    if (parsed < _minH || parsed > _maxH) {
                      setLocalState(() => errorText = "Height must be between $_minH and $_maxH");
                      return;
                    }

                    _setHeight(parsed);
                    Navigator.pop(ctx);
                  },
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

              // ✅ Big height + unit (tap = manual input)
              GestureDetector(
                onTap: _showManualHeightInput,
                child: Column(
                  children: [
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
                        AppRoutes.weight,
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
