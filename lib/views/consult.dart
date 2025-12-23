import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class Consultation extends StatefulWidget {
  const Consultation({super.key});

  // ukuran figma
  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<Consultation> createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  /// 0 = Nutritionists, 1 = Fitness Trainer, 2 = Recipe
  int? selectedRole;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final sx = size.width / Consultation._designW;
    final sy = size.height / Consultation._designH;

    double w(double v) => v * sx;
    double h(double v) => v * sy;

    const bg = Color(0xFF212020);
    const green = Color(0xFF588D6E);
    const lime = Color(0xFFE2F163);

    void goBack() {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }

    String? _routeForRole() {
      if (selectedRole == 0) return AppRoutes.nutri1; // NUTRITIONISTS
      if (selectedRole == 1) return AppRoutes.trainer1; // TRAINER
      if (selectedRole == 2) return AppRoutes.recipe; // RECIPE
      return null;
    }

    Widget roleButton({
      required int index,
      required String label,
      required String pngPath,
    }) {
      final bool isSelected = selectedRole == index;

      return GestureDetector(
        onTap: () => setState(() => selectedRole = index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              width: w(120),
              height: w(120),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? const Color(0xFF6DBF4D) // ✅ background hijau saat selected
                    : Colors.transparent, // ✅ kalau belum selected transparan
                border: Border.all(
                  color: Colors.white.withOpacity(0.55),
                  width: w(1),
                ),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                pngPath,
                width: w(58),
                height: w(58),
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: h(12)),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: w(14),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
                decorationColor: lime,
              ),
            ),
          ],
        ),
      );
    }

    final bool canContinue = selectedRole != null;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w(20)),
          child: Column(
            children: [
              SizedBox(height: h(10)),

              // ===== TOP BAR: Back + Title =====
              Row(
                children: [
                  GestureDetector(
                    onTap: goBack,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        color: lime,
                        fontSize: w(12),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: h(10)),

              Text(
                'Pick Your Option',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: w(22),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700
                ),
              ),

              SizedBox(height: h(28)),

              // ===== OPTIONS =====
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: h(18)),
                  child: Column(
                    children: [
                      roleButton(
                        index: 0,
                        label: 'Nutritionists',
                        pngPath: 'assets/images/nutri.png', // ✅ ganti sesuai asset kamu
                      ),
                      SizedBox(height: h(26)),
                      roleButton(
                        index: 1,
                        label: 'Fitness\nTrainer',
                        pngPath: 'assets/images/fitness.png', // ✅ ganti sesuai asset kamu
                      ),
                      SizedBox(height: h(26)),
                      roleButton(
                        index: 2,
                        label: 'Recipe',
                        pngPath: 'assets/images/recipe.png', // ✅ ganti sesuai asset kamu
                      ),
                    ],
                  ),
                ),
              ),

              // ===== CONTINUE BUTTON =====
              GestureDetector(
                onTap: canContinue
                    ? () {
                  final route = _routeForRole();
                  if (route != null) {
                    Navigator.pushNamed(context, route);
                  }
                }
                    : null,
                child: Opacity(
                  opacity: canContinue ? 1 : 0.45,
                  child: Container(
                    width: w(180),
                    height: h(44),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.09),
                      borderRadius: BorderRadius.circular(w(100)),
                      border: Border.all(color: Colors.white, width: w(0.5)),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w(14),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.underline,
                        decorationColor: lime,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: h(18)),
            ],
          ),
        ),
      ),
    );
  }
}
