import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _showManualAgeInput() async {
    final controller = TextEditingController(text: _age.toString());
    String? errorText;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setLocalState) {
            void validate(String v) {
              if (v.trim().isEmpty) {
                setLocalState(() => errorText = "Age can't be empty");
                return;
              }
              final parsed = int.tryParse(v);
              if (parsed == null) {
                setLocalState(() => errorText = "Please enter a valid number");
                return;
              }
              if (parsed < _minAge || parsed > _maxAge) {
                setLocalState(
                      () => errorText = "Age must be between $_minAge and $_maxAge",
                );
                return;
              }
              setLocalState(() => errorText = null);
            }

            return AlertDialog(
              backgroundColor: const Color(0xFF232222),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                "Enter your age",
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
                  hintText: "e.g. 28",
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
                    _setAge(int.parse(v));
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
                      setLocalState(() => errorText = "Age can't be empty");
                      return;
                    }
                    if (parsed == null) {
                      setLocalState(() => errorText = "Please enter a valid number");
                      return;
                    }
                    if (parsed < _minAge || parsed > _maxAge) {
                      setLocalState(
                            () => errorText = "Age must be between $_minAge and $_maxAge",
                      );
                      return;
                    }

                    _setAge(parsed);
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

              // ✅ Big Age (tap to input manual)
              GestureDetector(
                onTap: _showManualAgeInput,
                child: Column(
                  children: [
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
                    const SizedBox(height: 8),
                    Text(
                      "Tap to type",
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

              const SizedBox(height: 70),

              // ✅ Swipe bar (geser kiri/kanan)
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  // swipe kanan -> age turun, swipe kiri -> age naik
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
                                  left: center - 59,
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
                      Navigator.pushNamed(
                        context,
                        AppRoutes.height,
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
