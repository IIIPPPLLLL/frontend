import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class Trainer extends StatelessWidget {
  const Trainer({super.key});

  // ukuran figma
  static const double _designW = 393;
  static const double _designH = 852;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ✅ scaling biar mirip figma di HP
    final sx = size.width / _designW;
    final sy = size.height / _designH;
    final s = sx < sy ? sx : sy;

    double w(double v) => v * s;
    double h(double v) => v * s;

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

    void goBack() {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }

    // ✅ canvas tinggi sesuai konten kamu (posisi sampai 901+)
    final contentCanvasH = h(960);
    final contentCanvasW = w(_designW);

    return Scaffold(
      backgroundColor: const Color(0xFF212020),

      // ✅Template NAVBAR (persis yang kamu kasih)
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
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: h(14)),
          child: Center(
            child: Container(
              width: contentCanvasW,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: const Color(0xFF212020),
                shape: RoundedRectangleBorder(
                  // ✅ HILANGKAN GARIS PUTIH SAMPING
                  // side: BorderSide(width: w(1), color: Colors.white),
                  borderRadius: BorderRadius.circular(w(20)),
                ),
              ),
              child: SizedBox(
                height: contentCanvasH,
                child: Stack(
                  children: [
                    // ===== BACK ICON (Figma) =====
                    Positioned(
                      left: w(20),
                      top: h(18),
                      child: GestureDetector(
                        onTap: goBack,
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

                    // ===== TITLE =====
                    Positioned(
                      left: w(60),
                      top: h(20),
                      child: Text(
                        'Fitness Trainer',
                        style: TextStyle(
                          color: const Color(0xFF588D6E),
                          fontSize: w(20),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // ===== TABS =====
                    Positioned(
                      left: w(35),
                      top: h(80),
                      child: Container(
                        width: w(157),
                        height: h(32),
                        padding: EdgeInsets.only(top: h(5), left: w(12), right: w(12), bottom: h(6)),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(38)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Beginner',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF232222),
                              fontSize: w(17),
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w500,
                              height: 1.18,
                              letterSpacing: -0.09,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ✅ INTERMEDIATE PAKAI ROUTE
                    Positioned(
                      left: w(202),
                      top: h(80),
                      child: GestureDetector(
                        onTap: () {
                          // ganti ke route yang kamu mau
                          Navigator.pushNamed(context, AppRoutes.trainer2);
                        },
                        child: Container(
                          width: w(157),
                          height: h(32),
                          padding: EdgeInsets.only(top: h(5), left: w(12), right: w(12), bottom: h(6)),
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE2F163),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(w(38)),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Intermediate',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: const Color(0xFF232222),
                                fontSize: w(17),
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                                height: 1.18,
                                letterSpacing: -0.09,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ===== FEATURED PROGRAM =====
                    Positioned(
                      left: w(40),
                      top: h(140),
                      child: Text(
                        'Featured Program',
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(24),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.04,
                        ),
                      ),
                    ),

                    // featured image
                    Positioned(
                      left: w(27),
                      top: h(180),
                      child: Container(
                        width: w(327),
                        height: h(193),
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/trainer-11.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(26)),
                          ),
                        ),
                      ),
                    ),

                    // overlay bottom
                    Positioned(
                      left: w(27),
                      top: h(393),
                      child: Container(
                        width: w(327),
                        height: h(40),
                        decoration: ShapeDecoration(
                          color: const Color(0xE5212020),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(w(26)),
                              bottomRight: Radius.circular(w(26)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(8),
                      top: h(380),
                      child: SizedBox(
                        width: w(359),
                        height: h(26),
                        child: Text(
                          '30-Day Healthy Life Challenge',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w(17),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    // ===== LET'S GO BEGINNER =====
                    Positioned(
                      left: w(31),
                      top: h(424),
                      child: Text(
                        "Let's Go Beginner",
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(18),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(31),
                      top: h(460),
                      child: Text(
                        "Explore Different Workout Styles",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: w(12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),

                    // ===== CARD 1 =====
                    Positioned(
                      left: w(27),
                      top: h(490),
                      child: Container(
                        width: w(333),
                        height: h(110),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(208.45),
                      top: h(490),
                      child: Container(
                        width: w(151.55),
                        height: h(110),
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/trainer-12.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(47.62),
                      top: h(498),
                      child: SizedBox(
                        width: w(149.49),
                        child: Text(
                          'Split Strength Training',
                          style: TextStyle(
                            color: const Color(0xFF212020),
                            fontSize: w(18),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(63.08),
                      top: h(560),
                      child: Text(
                        '12 Minutes',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(139.37),
                      top: h(560),
                      child: Text(
                        '1250 Kcal',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(65),
                      top: h(580),
                      child: Text(
                        '5 exercises',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    // ===== CARD 2 =====
                    Positioned(
                      left: w(25),
                      top: h(620),
                      child: Container(
                        width: w(335),
                        height: h(110),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(208),
                      top: h(620),
                      child: Container(
                        width: w(152),
                        height: h(110),
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/trainer-13.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(46),
                      top: h(629),
                      child: SizedBox(
                        width: w(155),
                        child: Text(
                          'Full Body Stretching',
                          style: TextStyle(
                            color: const Color(0xFF212020),
                            fontSize: w(18),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(61),
                      top: h(695),
                      child: Text(
                        '45 Minutes',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(138),
                      top: h(695),
                      child: Text(
                        '1450 Kcal',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(61),
                      top: h(715),
                      child: Text(
                        '5 exercises',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    // ===== CARD 3 =====
                    Positioned(
                      left: w(25),
                      top: h(778),
                      child: Container(
                        width: w(335),
                        height: h(110),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(207.54),
                      top: h(778),
                      child: Container(
                        width: w(152.46),
                        height: h(110),
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/trainer-14.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(46.78),
                      top: h(783),
                      child: SizedBox(
                        width: w(160.76),
                        child: Text(
                          'Full Body Stretching',
                          style: TextStyle(
                            color: const Color(0xFF212020),
                            fontSize: w(18),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 1.28,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(61.30),
                      top: h(850),
                      child: Text(
                        '45 Minutes',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(141.39),
                      top: h(851),
                      child: Text(
                        '2000 Kcal',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(61.30),
                      top: h(866),
                      child: Text(
                        '7 exercises',
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(12),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
