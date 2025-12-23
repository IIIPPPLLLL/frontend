import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class Recipe extends StatefulWidget {
  const Recipe({super.key});

  // ukuran figma
  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<Recipe> createState() => _RecipeState();
}

class _RecipeState extends State<Recipe> {
  // ✅ toggle star per gambar
  bool starBanner = false;
  bool starRecLeft = false;
  bool starRecRight = false;
  bool starForYou1 = false;
  bool starForYou2 = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // ✅ Scaling (UNIFORM) biar gak ketarik di HP
    final sx = size.width / Recipe._designW;
    final sy = size.height / Recipe._designH;
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

    // ✅ STAR WIDGET (tap -> kuning)
    Widget starToggle({
      required bool isOn,
      required VoidCallback onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SvgPicture.asset(
          isOn ? 'assets/icons/starfix.svg' : 'assets/icons/logo-star.svg',
          width: w(16),
          height: w(16),
          placeholderBuilder: (_) => Container(
            width: w(16),
            height: w(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(w(4)),
            ),
          ),
        ),
      );
    }

    Widget starOnImage({
      required double left,
      required double top,
      required bool isOn,
      required VoidCallback onTap,
    }) {
      return Positioned(
        left: left,
        top: top,
        child: starToggle(isOn: isOn, onTap: onTap),
      );
    }

    // ✅ CANVAS HEIGHT dibenerin (layout kamu lewat 852, jadi kepotong kalau gak 960)
    final contentCanvasW = w(Recipe._designW);
    final contentCanvasH = h(960);

    return Scaffold(
      backgroundColor: const Color(0xFF212020),

      // ✅ NAVBAR
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
                  side: BorderSide(width: w(1), color: Colors.white),
                  borderRadius: BorderRadius.circular(w(20)),
                ),
              ),
              child: SizedBox(
                height: contentCanvasH,
                child: Stack(
                  children: [
                    // ===== BACK BUTTON =====
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
                      left: w(54),
                      top: h(61),
                      child: Text(
                        'Recipe',
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
                      top: h(102),
                      child: Container(
                        width: w(157),
                        height: h(32),
                        padding: EdgeInsets.only(
                          top: h(8),
                          left: w(12),
                          right: w(12),
                          bottom: h(6),
                        ),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE2F163),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(38)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Meal Plans',
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
                    Positioned(
                      left: w(201),
                      top: h(102),
                      child: Container(
                        width: w(157),
                        height: h(32),
                        padding: EdgeInsets.only(
                          top: h(8),
                          left: w(12),
                          right: w(12),
                          bottom: h(6),
                        ),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(38)),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Meal Ideas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF040306),
                              fontSize: w(17),
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w400,
                              height: 1.18,
                              letterSpacing: -0.09,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ===== BANNER IMAGE =====
                    Positioned(
                      left: w(35),
                      top: h(179),
                      child: Container(
                        width: w(323),
                        height: h(198),
                        decoration: ShapeDecoration(
                          image: const DecorationImage(
                            image: AssetImage("assets/images/carrot.png"),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                      ),
                    ),
                    // ✅ STAR banner
                    starOnImage(
                      left: w(35) + w(323) - w(16) - w(10),
                      top: h(179) + h(10),
                      isOn: starBanner,
                      onTap: () => setState(() => starBanner = !starBanner),
                    ),

                    // ===== "Recipe of the day" LABEL =====
                    Positioned(
                      left: w(233),
                      top: h(179),
                      child: Container(
                        width: w(125),
                        height: h(21),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE2F163),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(w(20)),
                              topRight: Radius.circular(w(20)),
                              bottomLeft: Radius.circular(w(20)),
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Recipe of the day',
                            style: TextStyle(
                              color: const Color(0xFF212020),
                              fontSize: w(12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ===== BANNER OVERLAY INFO =====
                    Positioned(
                      left: w(35),
                      top: h(337),
                      child: Container(
                        width: w(323),
                        height: h(40),
                        decoration: ShapeDecoration(
                          color: const Color(0xE5212020),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(w(20)),
                              bottomRight: Radius.circular(w(20)),
                            ),
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              left: w(17),
                              top: h(10),
                              child: Text(
                                'Carrot and orange smoothie',
                                style: TextStyle(
                                  color: const Color(0xFFE2F163),
                                  fontSize: w(14),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Positioned(
                              left: w(27.44),
                              top: h(28),
                              child: Text(
                                '10 Minutes',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w(12),
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                            Positioned(
                              left: w(101),
                              top: h(28),
                              child: Text(
                                '20 Cal',
                                style: TextStyle(
                                  color: Colors.white,
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

                    // ===== HEADINGS =====
                    Positioned(
                      left: w(34),
                      top: h(419),
                      child: Text(
                        'Recommended',
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(20),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Positioned(
                      left: w(34),
                      top: h(603),
                      child: Text(
                        'Recipes for you',
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(20),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // ===== RECOMMENDED CARDS =====
                    Positioned(
                      left: w(35),
                      top: h(454),
                      child: Container(
                        width: w(157),
                        height: h(138),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: w(1), color: Colors.white),
                            borderRadius: BorderRadius.circular(w(16)),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: w(157),
                              height: h(92),
                              decoration: const ShapeDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/stoberi.png"),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: w(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'fruit smoothie',
                                      style: TextStyle(
                                        color: const Color(0xFFE2F163),
                                        fontSize: w(12),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: h(4)),
                                    Row(
                                      children: [
                                        Text(
                                          '12 Minutes',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(width: w(20)),
                                        Text(
                                          '120 Cal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    starOnImage(
                      left: w(35) + w(157) - w(16) - w(10),
                      top: h(454) + h(10),
                      isOn: starRecLeft,
                      onTap: () => setState(() => starRecLeft = !starRecLeft),
                    ),

                    Positioned(
                      left: w(201),
                      top: h(454),
                      child: Container(
                        width: w(157),
                        height: h(138),
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: w(1), color: Colors.white),
                            borderRadius: BorderRadius.circular(w(16)),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: w(157),
                              height: h(92),
                              decoration: const ShapeDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/salad3.png"),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: w(12)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Salads with quinoa',
                                      style: TextStyle(
                                        color: const Color(0xFFE2F163),
                                        fontSize: w(12),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    SizedBox(height: h(4)),
                                    Row(
                                      children: [
                                        Text(
                                          '12 Minutes',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(width: w(20)),
                                        Text(
                                          '120 Cal',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    starOnImage(
                      left: w(201) + w(157) - w(16) - w(10),
                      top: h(454) + h(10),
                      isOn: starRecRight,
                      onTap: () => setState(() => starRecRight = !starRecRight),
                    ),

                    // ===== RECIPES FOR YOU CARDS =====
                    Positioned(
                      left: w(35),
                      top: h(642),
                      child: Container(
                        width: w(323),
                        height: h(110),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: w(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Delights with Greek yogurt',
                                      style: TextStyle(
                                        color: const Color(0xFF212020),
                                        fontSize: w(18),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: h(8)),
                                    Row(
                                      children: [
                                        Text(
                                          '3 Minutes',
                                          style: TextStyle(
                                            color: const Color(0xFF212020),
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(width: w(14)),
                                        Text(
                                          '200 Cal',
                                          style: TextStyle(
                                            color: const Color(0xFF212020),
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: w(148),
                              height: h(110),
                              decoration: ShapeDecoration(
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/yogurt2.png"),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w(20)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    starOnImage(
                      left: w(35) + w(323) - w(16) - w(10),
                      top: h(642) + h(10),
                      isOn: starForYou1,
                      onTap: () => setState(() => starForYou1 = !starForYou1),
                    ),

                    Positioned(
                      left: w(35),
                      top: h(768),
                      child: Container(
                        width: w(323),
                        height: h(110),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(w(20)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: w(20)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Baked salmon',
                                      style: TextStyle(
                                        color: const Color(0xFF212020),
                                        fontSize: w(18),
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        height: 1.2,
                                      ),
                                    ),
                                    SizedBox(height: h(8)),
                                    Row(
                                      children: [
                                        Text(
                                          '30 Minutes',
                                          style: TextStyle(
                                            color: const Color(0xFF212020),
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        SizedBox(width: w(14)),
                                        Text(
                                          '350 Cal',
                                          style: TextStyle(
                                            color: const Color(0xFF212020),
                                            fontSize: w(12),
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: w(148),
                              height: h(110),
                              decoration: ShapeDecoration(
                                image: const DecorationImage(
                                  image: AssetImage("assets/images/salmon2.png"),
                                  fit: BoxFit.cover,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(w(20)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    starOnImage(
                      left: w(35) + w(323) - w(16) - w(10),
                      top: h(768) + h(10),
                      isOn: starForYou2,
                      onTap: () => setState(() => starForYou2 = !starForYou2),
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
