import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class MealPlans2 extends StatefulWidget {
  const MealPlans2({super.key});

  // ukuran figma
  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<MealPlans2> createState() => _MealPlans2State();
}

class _MealPlans2State extends State<MealPlans2> {
  // ====== STATE ======
  String? dietaryPref;
  String? allergy;
  String? mealType;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final sx = size.width / MealPlans2._designW;
    final sy = size.height / MealPlans2._designH;

    double w(double v) => v * sx;
    double h(double v) => v * sy;

    Widget svgPlaceholder({
      required String assetPath,
      required double width,
      required double height,
      Color? color,
    }) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(color, BlendMode.srcIn),
        placeholderBuilder: (_) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(w(6)),
          ),
        ),
      );
    }

    Widget sectionTitle(String text) => Padding(
      padding: EdgeInsets.only(bottom: h(6)),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFFE2F163),
          fontSize: w(18),
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    Widget sectionSubtitle(String text) => Padding(
      padding: EdgeInsets.only(bottom: h(10)),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: w(12),
          fontFamily: 'League Spartan',
          fontWeight: FontWeight.w300,
        ),
      ),
    );

    Widget optionRow({
      required String? groupValue,
      required void Function(String?) onChanged,
      required List<String> left,
      required List<String> right,
    }) {
      Widget radioItem(String value) {
        final isSelected = value == groupValue;
        return InkWell(
          onTap: () => onChanged(value),
          child: Row(
            children: [
              Radio<String>(
                value: value,
                groupValue: groupValue,
                onChanged: onChanged,
                activeColor: const Color(0xFFE2F163),
              ),
              Text(
                value,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFFE2F163)
                      : Colors.white,
                  fontSize: w(12),
                  fontFamily: 'League Spartan',
                  decoration:
                  isSelected ? TextDecoration.underline : null,
                ),
              ),
            ],
          ),
        );
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(children: left.map(radioItem).toList()),
          ),
          Expanded(
            child: Column(children: right.map(radioItem).toList()),
          ),
        ],
      );
    }

    final bool canContinue =
        dietaryPref != null && allergy != null && mealType != null;

    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Stack(
          children: [
            // ===== BACK BUTTON =====
            Positioned(
              left: w(16),
              top: h(16),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context,AppRoutes.meal),
                child: Container(
                  width: w(36),
                  height: w(36),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: w(16),
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // ===== CONTENT =====
            Positioned.fill(
              child: SingleChildScrollView(
                padding:
                EdgeInsets.fromLTRB(w(28), h(16), w(28), h(90)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: w(30)),
                      child: Text(
                        'Meal plans',
                        style: TextStyle(
                          color: const Color(0xFF588D6E),
                          fontSize: w(25),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: h(18)),

                    // Dietary Preferences
                    sectionTitle('Dietary Preferences'),
                    sectionSubtitle(
                        'What are your dietary preferences?'),
                    optionRow(
                      groupValue: dietaryPref,
                      onChanged: (v) =>
                          setState(() => dietaryPref = v),
                      left: const [
                        'Vegetarian',
                        'Vegan',
                        'Gluten Free'
                      ],
                      right: const [
                        'Keto',
                        'Paleo',
                        'No preferences'
                      ],
                    ),
                    SizedBox(height: h(22)),

                    // Allergies
                    sectionTitle('Allergies'),
                    sectionSubtitle(
                        'Do you have any food allergies we should know'),
                    optionRow(
                      groupValue: allergy,
                      onChanged: (v) =>
                          setState(() => allergy = v),
                      left: const ['Nuts', 'Dairy', 'Shellfish'],
                      right: const ['Eggs', 'No allergies'],
                    ),
                    SizedBox(height: h(22)),

                    // Meal Types
                    sectionTitle('Meal Types'),
                    sectionSubtitle(
                        'Which meals do you want to plan?'),
                    optionRow(
                      groupValue: mealType,
                      onChanged: (v) =>
                          setState(() => mealType = v),
                      left: const ['Breakfast', 'Lunch'],
                      right: const ['Dinner', 'Snacks'],
                    ),
                    SizedBox(height: h(26)),

                    // Continue Button
                    Center(
                      child: GestureDetector(
                        onTap: canContinue
                            ? () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.meal3, // ⬅️ page berikutnya
                            arguments: {
                              'dietaryPref': dietaryPref,
                              'allergy': allergy,
                              'mealType': mealType,
                            },
                          );
                        }
                            : null,
                        child: Opacity(
                          opacity: canContinue ? 1 : 0.5,
                          child: Container(
                            width: w(220),
                            height: h(44),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(w(100)),
                              border:
                              Border.all(color: Colors.white),
                            ),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w(16),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                decoration:
                                TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== BOTTOM NAVBAR (template kamu) =====
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: h(59),
                color: const Color(0xFF588D6E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.home),
                      child: svgPlaceholder(
                        assetPath: 'assets/icons/logo-home2.svg',
                        width: w(26),
                        height: w(26),
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.tracking),
                      child: svgPlaceholder(
                        assetPath: 'assets/icons/icon-doc.svg',
                        width: w(26),
                        height: w(26),
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.home),
                      child: svgPlaceholder(
                        assetPath: 'assets/icons/logo-star.svg',
                        width: w(26),
                        height: w(26),
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.profile),
                      child: svgPlaceholder(
                        assetPath: 'assets/icons/logo-profile2.svg',
                        width: w(26),
                        height: w(26),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
