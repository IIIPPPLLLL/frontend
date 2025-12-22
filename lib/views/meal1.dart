import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class MealPlans extends StatelessWidget {
  const MealPlans({super.key});

  // ukuran figma
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

    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              // background image
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(w(20)),
                  child: Image.asset(
                    "assets/images/back-mealplans.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // overlay gelap
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.30),
                ),
              ),

              // back button (placeholder icon)
              Positioned(
                left: w(20),
                top: h(18),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox(
                    width: w(32),
                    height: w(32),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: w(16),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              // content center
              Positioned(
                left: w(0),
                right: w(0),
                top: h(300),
                child: Column(
                  children: [
                    // placeholder logo/icon (yang di figma ada icon)
                    Container(
                      width: w(48),
                      height: w(48),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/apple.svg',
                          width: w(24),
                          height: w(24),
                          color: Colors.white,
                        ),


                      ),
                    ),
                    SizedBox(height: h(12)),

                    Text(
                      'Meal Plans',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: w(20),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: h(12)),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: w(50)),
                      child: Text(
                        'Smart meal plans, made for your lifestyle.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w(18),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                          height: 1.2,
                        ),
                      ),
                    ),

                    SizedBox(height: h(26)),

                    // button "Know your plan"
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.meal2), // ganti route sesuai kebutuhan
                      child: Container(
                        width: w(250),
                        height: h(40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.09),
                          borderRadius: BorderRadius.circular(w(100)),
                          border: Border.all(color: Colors.white, width: w(0.5)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Know your plan',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w(18), // 20 di figma suka kepotong di hp kecil
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom navbar (dari kamu) — FIX HP: pakai w/h local
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
