import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class MealPlans5 extends StatelessWidget {
  const MealPlans5({super.key});

  static const double _designW = 393;
  static const double _designH = 852;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sx = size.width / _designW;
    final sy = size.height / _designH;

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
        colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
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

    Widget pillButton({
      required String text,
      required VoidCallback onTap,
      required double width,
    }) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: width,
          height: h(40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.09),
            borderRadius: BorderRadius.circular(w(100)),
            border: Border.all(color: Colors.white, width: w(0.5)),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: w(16),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF212020),

      // navbar fixed bawah (template kamu)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: h(30) + h(27),
          color: const Color(0xFF588D6E),
          child: Column(
            children: [
              SizedBox(height: h(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: svgPlaceholder(
                      assetPath: 'assets/icons/logo-home2.svg',
                      width: w(26),
                      height: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.tracking),
                    child: svgPlaceholder(
                      assetPath: 'assets/icons/icon-doc.svg',
                      width: w(26),
                      height: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: svgPlaceholder(
                      assetPath: 'assets/icons/logo-star.svg',
                      width: w(26),
                      height: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: svgPlaceholder(
                      assetPath: 'assets/icons/logo-profile2.svg',
                      width: w(26),
                      height: w(26),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w(16)),
          child: Column(
            children: [
              SizedBox(height: h(8)),

              // ===== Header (Back + Title) =====
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, AppRoutes.home);
                      }
                    },
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
                  SizedBox(width: w(10)),
                  Text(
                    'Meal Plans',
                    style: TextStyle(
                      color: const Color(0xFF588D6E),
                      fontSize: w(20),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h(14)),

              // ===== Content scrollable biar FIX HP =====
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: h(16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row + star
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Avocado And Egg Toast',
                              style: TextStyle(
                                color: const Color(0xFFE2F163),
                                fontSize: w(20),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                              ),
                            ),
                          ),
                          // ⭐ placeholder star (ganti svg kamu)
                          Padding(
                            padding: EdgeInsets.only(top: h(2)),
                            child: svgPlaceholder(
                              assetPath: 'assets/icons/logo-star.svg', // ⬅️ ganti icon star detail
                              width: w(16),
                              height: w(16),
                              color: const Color(0xFFE2F163),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h(10)),

                      // Minutes + Cal row
                      Row(
                        children: [
                          svgPlaceholder(
                            assetPath: 'assets/icons/ic_clock.svg', // ⬅️ ganti icon clock
                            width: w(12),
                            height: w(12),
                            color: Colors.white,
                          ),
                          SizedBox(width: w(6)),
                          Text(
                            '15 Minutes',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w(14),
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: w(18)),
                          svgPlaceholder(
                            assetPath: 'assets/icons/ic_fire.svg', // ⬅️ ganti icon fire
                            width: w(12),
                            height: w(12),
                            color: Colors.white,
                          ),
                          SizedBox(width: w(6)),
                          Text(
                            '150 Cal',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: w(14),
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h(16)),

                      // Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(w(20)),
                        child: Image.asset(
                          'assets/images/toast2.png',
                          width: double.infinity,
                          height: h(198),
                          fit: BoxFit.cover,
                        ),
                      ),

                      SizedBox(height: h(18)),

                      // Ingredients
                      Text(
                        'Ingredients',
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(14),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: h(8)),
                      Text(
                        '• Wholemeal bread\n• Ripe avocado slices\n• Fried or poached egg',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w(14),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                          height: 1.35,
                        ),
                      ),

                      SizedBox(height: h(16)),

                      // Preparation
                      Text(
                        'Preparation',
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(14),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: h(8)),
                      Text(
                        'Sed earum sequi est magnam doloremque aut porro dolores sit molestiae fuga. Et rerum inventore ut perspiciatis dolorum sed internos porro aut labore dolorem. At quia reiciendis in consequuntur possimus.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w(14),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                          height: 1.25,
                        ),
                      ),

                      SizedBox(height: h(18)),

                      // Buttons row
                      Row(
                        children: [
                          Expanded(
                            child: pillButton(
                              text: 'Save Recipe',
                              width: double.infinity,
                              onTap: () {
                                // ✅ route save recipe (ganti sesuai project kamu)
                                Navigator.pushNamed(context, AppRoutes.home);
                              },
                            ),
                          ),
                          SizedBox(width: w(12)),
                          Expanded(
                            child: pillButton(
                              text: 'Share Recipe',
                              width: double.infinity,
                              onTap: () {
                                // placeholder (kalau mau share beneran nanti pake share_plus)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Share clicked')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: h(18)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
