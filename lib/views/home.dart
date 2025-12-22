import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  // Figma artboard kamu
  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // ✅ 4 bintang buat 4 kotak gede
  bool _starRecLeft = false;
  bool _starRecRight = false;
  bool _starArtLeft = false;
  bool _starArtRight = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Scale biar “fix ke HP” tapi tetap preserve posisi figma
    final sx = size.width / Home._designW;
    final sy = size.height / Home._designH;

    double w(double v) => v * sx;
    double h(double v) => v * sy;

    // ✅ geser ke atas bagian bawah biar ga ketutup navbar
    // kalau masih kurang, ubah nilai ini (misal -24 atau -30)
    const double liftBottomSection = 70;
    double up(double top) => top - liftBottomSection;

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

    // ✅ widget bintang toggle (putih <-> kuning)
    Widget favStar({
      required bool isOn,
      required VoidCallback onToggle,
      required double size,
    }) {
      return GestureDetector(
        onTap: onToggle,
        behavior: HitTestBehavior.opaque,
        child: SvgPicture.asset(
          isOn ? 'assets/icons/starfix.svg' : 'assets/icons/starputih.svg',
          width: size,
          height: size,
          // jangan kasih color, biar warna dari SVG kepake
        ),
      );
    }

    // Card rekomendasi (kiri/kanan)
    Widget recommendationCard({
      required double left,
      required double top,
      required String title,
      required String imagePlaceholder,
      required bool isStarOn,
      required VoidCallback onStarToggle,
      VoidCallback? onTap,
    }) {
      return Positioned(
        left: w(left),
        top: h(top),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: w(190),
            height: h(156),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: w(1)),
              borderRadius: BorderRadius.circular(w(16)),
            ),
            child: Stack(
              children: [
                // image
                Positioned(
                  left: 0,
                  top: 0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(w(16)),
                      topRight: Radius.circular(w(16)),
                    ),
                    child: Image.asset(
                      imagePlaceholder,
                      width: w(157),
                      height: h(92),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // ✅ star (top-right) toggle
                Positioned(
                  right: w(10),
                  top: h(10),
                  child: SizedBox(
                    width: w(16),
                    height: w(16),
                    child: favStar(
                      isOn: isStarOn,
                      onToggle: onStarToggle,
                      size: w(16),
                    ),
                  ),
                ),

                // title
                Positioned(
                  left: w(12),
                  top: h(96),
                  right: w(12),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFFE2F163),
                      fontSize: w(12),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                // play button (bottom-right)
                Positioned(
                  right: w(10),
                  bottom: h(10),
                  child: Container(
                    width: w(23),
                    height: w(23),
                    decoration: const BoxDecoration(
                      color: Color(0xFF6DBF4D),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: svgPlaceholder(
                      assetPath: 'assets/icons/icon-play.svg',
                      width: w(12),
                      height: w(12),
                      color: Colors.white,
                    ),
                  ),
                ),

                // info row (minutes + kcal)
                // info row (minutes + kcal) — FIX: anti overflow + rapi kaya figma
                Positioned(
                  left: w(12),
                  right: w(36), // ✅ kasih ruang supaya nggak tabrakan sama tombol play
                  bottom: h(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // left group: clock + minutes
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            svgPlaceholder(
                              assetPath: 'assets/icons/ic_clock.svg',
                              width: w(12),
                              height: w(12),
                              color: Colors.white,
                            ),
                            SizedBox(width: w(4)),
                            Flexible(
                              child: Text(
                                '12 Minutes',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w(12),
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w300,
                                  height: 1.1, // ✅ align baseline biar rapih
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: w(10)),

                      // right group: fire + kcal
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            svgPlaceholder(
                              assetPath: 'assets/icons/ic_fire.svg',
                              width: w(12),
                              height: w(12),
                              color: Colors.white,
                            ),
                            SizedBox(width: w(4)),
                            Flexible(
                              child: Text(
                                '120 Kcal',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w(12),
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w300,
                                  height: 1.1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
    }

    // Article card bawah
    Widget articleCard({
      required double left,
      required double top,
      required String title,
      required String imagePlaceholder,
      required bool isStarOn,
      required VoidCallback onStarToggle,
      VoidCallback? onTap,
    }) {
      return Positioned(
        left: w(left),
        top: h(top),
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            width: w(157),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(w(15)),
                      child: Image.asset(
                        imagePlaceholder,
                        width: w(157),
                        height: h(134),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // ✅ star (top-right) toggle
                    Positioned(
                      right: w(10),
                      top: h(10),
                      child: SizedBox(
                        width: w(16),
                        height: w(16),
                        child: favStar(
                          isOn: isStarOn,
                          onToggle: onStarToggle,
                          size: w(16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: h(8)),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: w(12),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
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
              Positioned.fill(child: Container(color: const Color(0xFF212020))),

              // Hi, Max
              Positioned(
                left: w(34),
                top: h(30),
                child: Text(
                  'Hi, Max',
                  style: TextStyle(
                    color: const Color(0xFF588D6E),
                    fontSize: w(20),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // subtitle
              Positioned(
                left: w(35),
                top: h(60),
                child: SizedBox(
                  width: w(240),
                  child: Text(
                    "It's time to challenge your limits.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w(13),
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Top-right icons
              Positioned(
                right: w(28),
                top: h(35),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                      child: SvgPicture.asset(
                        'assets/icons/logo-search.svg',
                        width: w(20),
                        height: w(20),
                        color: const Color(0xFF588D6E),
                      ),
                    ),
                    SizedBox(width: w(14)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.notif),
                      child: svgPlaceholder(
                        assetPath: 'assets/icons/logo-notif.svg',
                        width: w(20),
                        height: w(20),
                        color: const Color(0xFF588D6E),
                      ),
                    ),
                    SizedBox(width: w(14)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                      child: svgPlaceholder(
                        assetPath: 'assets/icons/logo-profile.svg',
                        width: w(20),
                        height: w(20),
                        color: const Color(0xFF588D6E),
                      ),
                    ),
                  ],
                ),
              ),

              // Progress tracking + Consultation + New Feature (tanpa divider)
              Positioned(
                left: w(35),
                top: h(95),
                child: SizedBox(
                  width: w(323),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 🔥 auto rapi
                    children: [
                      // ===== Progress Tracking =====
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.tracking),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/progress-tracking.svg',
                              width: w(26),
                              height: w(26),
                              color: Colors.white,
                            ),
                            SizedBox(height: h(6)),
                            Text(
                              'Progress\nTracking',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w(12),
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w300,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ===== Consultation =====
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.consult),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/logo-consultation.svg',
                              width: w(26),
                              height: w(26),
                              color: Colors.white,
                            ),
                            SizedBox(height: h(6)),
                            Text(
                              'Consultation',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w(12),
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ===== NEW FEATURE (PLACEHOLDER) =====
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.meal),
                        child: Column(
                          children: [
                            // 🔧 SVG placeholder (ganti asset nanti)
                            SvgPicture.asset(
                              'assets/icons/meal-menu.svg',
                              width: w(26),
                              height: w(26),
                              color: Colors.white,
                            ),
                            SizedBox(height: h(6)),
                            Text(
                              'Meal\nPlans',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w(12),
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w300,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),




              // Recommendations header
              Positioned(
                left: w(38),
                top: h(155),
                child: Text(
                  'Recommendations',
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: w(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // See All + arrow
              Positioned(
                right: w(35),
                top: h(160),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.recomend),
                  child: Row(
                    children: [
                      Text(
                        'See All',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: w(12),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: w(8)),
                      svgPlaceholder(
                        assetPath: 'assets/icons/icon-play.svg',
                        width: w(14),
                        height: w(14),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              // ✅ Recommendation cards (with star toggle)
              recommendationCard(
                left: 5,
                top: 185,
                title: 'Squat Exercise',
                imagePlaceholder: 'assets/images/squat.png',
                isStarOn: _starRecLeft,
                onStarToggle: () => setState(() => _starRecLeft = !_starRecLeft),
                onTap: () => Navigator.pushNamed(context, AppRoutes.home),
              ),
              recommendationCard(
                left: 201,
                top: 185,
                title: 'Blackened Chicken Avocado',
                imagePlaceholder: 'assets/images/chicken.png',
                isStarOn: _starRecRight,
                onStarToggle: () => setState(() => _starRecRight = !_starRecRight),
                onTap: () => Navigator.pushNamed(context, AppRoutes.home),
              ),

              // ✅ Today’s Schedule title (naik)
              Positioned(
                left: w(38),
                top: h(up(420)),
                child: Text(
                  "Today’s Schedule",
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: w(24),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    height: 1.04,
                  ),
                ),
              ),

              // ✅ Schedule card (naik)
              Positioned(
                left: w(39),
                top: h(up(451)),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                  child: Container(
                    width: w(327),
                    height: h(102),
                    decoration: BoxDecoration(
                      color: const Color(0xFF588D6E),
                      borderRadius: BorderRadius.circular(w(23)),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: w(20),
                          top: h(18),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(w(999)),
                            child: Image.asset(
                              'assets/images/salad.png',
                              width: w(60),
                              height: h(57),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          left: w(95),
                          top: h(16),
                          child: Text(
                            'Breakfast',
                            style: TextStyle(
                              color: const Color(0xFFF8F9F2),
                              fontSize: w(15),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          left: w(95),
                          top: h(42),
                          right: w(16),
                          child: Text(
                            'Air Fryer honey garlic Salom + Protein Shake',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFFF8F9F2),
                              fontSize: w(12),
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Positioned(
                          left: w(95),
                          bottom: h(14),
                          child: Row(
                            children: [
                              svgPlaceholder(
                                assetPath: 'assets/icons/ic_clock.svg',
                                width: w(12),
                                height: w(12),
                                color: Colors.white,
                              ),
                              SizedBox(width: w(6)),
                              Text(
                                '7:00 AM',
                                style: TextStyle(
                                  color: const Color(0xFFF8F9F2),
                                  fontSize: w(10),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ✅ Articles & Tips (naik)
              Positioned(
                left: w(35),
                top: h(up(575)),
                child: Text(
                  'Articles & Tips',
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: w(14),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // ✅ Article cards (naik + star toggle)
              articleCard(
                left: 35,
                top: up(611),
                title: 'Supplement Guide...',
                imagePlaceholder: 'assets/images/woman-gym.png',
                isStarOn: _starArtLeft,
                onStarToggle: () => setState(() => _starArtLeft = !_starArtLeft),
                onTap: () => Navigator.pushNamed(context, AppRoutes.home),
              ),
              articleCard(
                left: 209,
                top: up(610),
                title: '15 Quick & Delicious Healthy Meal',
                imagePlaceholder: 'assets/images/salad.png',
                isStarOn: _starArtRight,
                onStarToggle: () => setState(() => _starArtRight = !_starArtRight),
                onTap: () => Navigator.pushNamed(context, AppRoutes.home),
              ),

              // Bottom navbar
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
