import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class Nutritionist1 extends StatefulWidget {
  const Nutritionist1({super.key});

  @override
  State<Nutritionist1> createState() => _Nutritionist1State();
}

class _Nutritionist1State extends State<Nutritionist1> {
  // ===== FAVORITE STATES (tiap star beda) =====
  bool _favFeatured = false;
  bool _favMeal1 = false;
  bool _favMeal2 = false;
  bool _favMeal3 = false;

  // ukuran figma
  static const double _designW = 393;
  static const double _designH = 852;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // scaling biar mirip figma di HP
    final sx = size.width / _designW;
    final sy = size.height / _designH;
    final s = sx < sy ? sx : sy;

    double w(double v) => v * s;
    double h(double v) => v * s;

    Widget svgIcon({
      required String assetPath,
      required double size,
      Color? color,
    }) {
      return SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
        placeholderBuilder: (_) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.yellow,
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

    // canvas tinggi sesuai konten kamu
    final contentCanvasH = h(960);
    final contentCanvasW = w(_designW);

    // ===== REUSABLE STAR BUTTON =====
    Widget starButton({
      required bool isFav,
      required VoidCallback onTap,
      double? buttonSize,
      double? iconSize,
    }) {
      final bs = buttonSize ?? w(30);
      final isz = iconSize ?? w(18);

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: bs,
          height: bs,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: svgIcon(
            assetPath: isFav ? 'assets/icons/starfix.svg' : 'assets/icons/logo-star.svg',
            size: isz,
            color: isFav ? null : Colors.white, // starkuning.svg biasanya udah warna kuning
          ),
        ),
      );
    }

    // ===== REUSABLE MEAL CARD (rapih & konsisten) =====
    Widget mealCard({
      required double top,
      required String title,
      required String timeText,
      required String calText,
      required String imageAsset,
      required bool isFav,
      required VoidCallback onFavTap,
    }) {
      final cardW = w(329);
      final cardH = h(110);
      final radius = w(20);

      return Positioned(
        left: w(32),
        top: top,
        child: Container(
          width: cardW,
          height: cardH,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              // LEFT TEXT
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: w(20), right: w(12), top: h(16), bottom: h(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: const Color(0xFF212020),
                          fontSize: w(18),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.05,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            timeText,
                            style: TextStyle(
                              color: const Color(0xFF212020),
                              fontSize: w(12),
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SizedBox(width: w(16)),
                          Text(
                            calText,
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

              // RIGHT IMAGE + STAR
              SizedBox(
                width: w(148),
                height: cardH,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(imageAsset, fit: BoxFit.cover),
                    Positioned(
                      top: w(10),
                      right: w(10),
                      child: starButton(
                        isFav: isFav,
                        onTap: onFavTap,
                        buttonSize: w(30),
                        iconSize: w(18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF212020),

      // NAVBAR
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
                    child: svgIcon(
                      assetPath: 'assets/icons/logo-home2.svg',
                      size: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.tracking),
                    child: svgIcon(
                      assetPath: 'assets/icons/icon-doc.svg',
                      size: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: svgIcon(
                      assetPath: 'assets/icons/logo-star.svg',
                      size: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: svgIcon(
                      assetPath: 'assets/icons/logo-profile2.svg',
                      size: w(26),
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
              decoration: const BoxDecoration(color: Color(0xFF212020)),
              child: SizedBox(
                height: contentCanvasH,
                child: Stack(
                  children: [
                    // BACK ICON
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

                    // TITLE
                    Positioned(
                      left: w(54),
                      top: h(61),
                      child: Text(
                        'Nutritionist',
                        style: TextStyle(
                          color: const Color(0xFF588D6E),
                          fontSize: w(20),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    // TABS (rapihin dikit spacing)
                    Positioned(
                      left: w(32),
                      top: h(102),
                      child: Container(
                        width: w(329),
                        height: h(32),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(w(38)),
                          color: Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: h(32),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(w(38)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Tips',
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
                            SizedBox(width: w(12)),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.nutri2);
                                },
                                child: Container(
                                  height: h(32),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2F163),
                                    borderRadius: BorderRadius.circular(w(38)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Consult',
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
                          ],
                        ),
                      ),
                    ),

                    // FEATURED PROGRAM
                    Positioned(
                      left: w(32),
                      top: h(188),
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

                    // FEATURED IMAGE (overlay + star dirapihin)
                    Positioned(
                      left: w(32),
                      top: h(226),
                      child: Container(
                        width: w(329),
                        height: h(194),
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(w(27)),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset("assets/images/rempah.png", fit: BoxFit.cover),

                            Positioned(
                              top: w(10),
                              right: w(10),
                              child: starButton(
                                isFav: _favFeatured,
                                onTap: () => setState(() => _favFeatured = !_favFeatured),
                              ),
                            ),

                            // bottom overlay label (lebih presisi & center)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: h(44),
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: w(12)),
                                decoration: BoxDecoration(
                                  color: const Color(0xE5212020),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(w(27)),
                                    bottomRight: Radius.circular(w(27)),
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '30–Day Healthy Eating Challenge',
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
                          ],
                        ),
                      ),
                    ),

                    // HEALTHY MEAL
                    Positioned(
                      left: w(32),
                      top: h(467),
                      child: Text(
                        'Healthy Meal',
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(24),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.04,
                        ),
                      ),
                    ),

                    // MEAL CARDS (rapih, konsisten, star toggle)
                    mealCard(
                      top: h(519),
                      title: 'Delights With Greek Yogurt',
                      timeText: '6 Minutes',
                      calText: '200 Cal',
                      imageAsset: "assets/images/yogurt.png",
                      isFav: _favMeal1,
                      onFavTap: () => setState(() => _favMeal1 = !_favMeal1),
                    ),
                    mealCard(
                      top: h(648),
                      title: 'Baked Salmon',
                      timeText: '30 Minutes',
                      calText: '350 Cal',
                      imageAsset: "assets/images/salmon2.png",
                      isFav: _favMeal2,
                      onFavTap: () => setState(() => _favMeal2 = !_favMeal2),
                    ),
                    mealCard(
                      top: h(775),
                      title: 'Teriyaki Chicken With Brown Rice',
                      timeText: '45 Minutes',
                      calText: '375 Cal',
                      imageAsset: "assets/images/teriyaki.png",
                      isFav: _favMeal3,
                      onFavTap: () => setState(() => _favMeal3 = !_favMeal3),
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
