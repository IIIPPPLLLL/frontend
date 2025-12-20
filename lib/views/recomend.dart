import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class Rekomendasi extends StatelessWidget {
  const Rekomendasi({super.key});

  static const double _designW = 393;
  static const double _designH = 852;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final sx = size.width / _designW;
    final sy = size.height / _designH;

    double w(double v) => v * sx;
    double h(double v) => v * sy;

    // ✅ placeholder icon (kamu ganti manual)
    Widget iconPlaceholder({
      required double width,
      required double height,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(w(6)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: SizedBox.expand(
          child: Stack(
            children: [
              // Background
              Positioned.fill(
                child: Container(color: const Color(0xFF232222)),
              ),

              // Title
              Positioned(
                left: w(35),
                top: h(30),
                child: Text(
                  'Healthy Picks for You',
                  style: TextStyle(
                    color: const Color(0xFF588D6E),
                    fontSize: w(20),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Exercises label
              Positioned(
                left: w(40),
                top: h(75),
                child: Text(
                  'Exercises',
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: w(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Meal label
              Positioned(
                left: w(40),
                top: h(230),
                child: Text(
                  'Meal',
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: w(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Articles label
              Positioned(
                left: w(40),
                top: h(400),
                child: Text(
                  'Articles',
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: w(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // Program label
              Positioned(
                left: w(40),
                top: h(560),
                child: Text(
                  'Program',
                  style: TextStyle(
                    color: const Color(0xFFE2F163),
                    fontSize: w(15),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // ===== EXERCISE CARD =====
              Positioned(
                left: w(32),
                top: h(100),
                child: Container(
                  width: w(343.81),
                  height: h(110),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(20)),
                  ),
                ),
              ),
              Positioned(
                left: w(53.29),
                top: h(110),
                child: SizedBox(
                  width: w(144.76),
                  child: Text(
                    'push-up exercise',
                    style: TextStyle(
                      color: const Color(0xFF212020),
                      fontSize: w(18),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(68.19),
                top: h(165),
                child: SizedBox(
                  width: w(48.96),
                  child: Text(
                    '7 Minutes',
                    style: TextStyle(
                      color: const Color(0xFF212020),
                      fontSize: w(12),
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(146.96),
                top: h(165),
                child: SizedBox(
                  width: w(35.13),
                  child: Text(
                    '70 Cal',
                    style: TextStyle(
                      color: const Color(0xFF212020),
                      fontSize: w(12),
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(215),
                top: h(100),
                child: Container(
                  width: w(164),
                  height: h(110),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w(12)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/push.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // ===== MEAL CARD =====
              Positioned(
                left: w(32),
                top: h(250),
                child: Container(
                  width: w(343),
                  height: h(110),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(20)),
                  ),
                ),
              ),
              Positioned(
                left: w(53.24),
                top: h(260),
                child: SizedBox(
                  width: w(144.42),
                  child: Text(
                    'Turkey and Avocado Wrap',
                    style: TextStyle(
                      color: const Color(0xFF212020),
                      fontSize: w(18),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(68.11),
                top: h(320),
                child: SizedBox(
                  width: w(53.10),
                  child: Text(
                    '15 Minutes',
                    style: TextStyle(
                      color: const Color(0xFF212020),
                      fontSize: w(12),
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(146.69),
                top: h(320),
                child: SizedBox(
                  width: w(41.41),
                  child: Text(
                    '230 Cal',
                    style: TextStyle(
                      color: const Color(0xFF212020),
                      fontSize: w(12),
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(217.84),
                top: h(250),
                child: Container(
                  width: w(157.16),
                  height: h(110),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w(20)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/kebab.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),

              // ===== ARTICLES GRID =====
              Positioned(
                left: w(36),
                top: h(420),
                child: Container(
                  width: w(153),
                  height: h(95),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w(15)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/salad.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(219),
                top: h(420),
                child: Container(
                  width: w(156),
                  height: h(98),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w(10)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/woman-stretch.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(39),
                top: h(520),
                child: SizedBox(
                  width: w(145),
                  child: Text(
                    '15 Quick & Delicious Healthy Meal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w(10),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(230),
                top: h(520),
                child: SizedBox(
                  width: w(159),
                  child: Text(
                    'Small Steps, Big Impact: The Secrets to Long-Term Healthy Living"',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: w(10),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              // ===== PROGRAM CARD =====
              Positioned(
                left: w(27),
                top: h(590),
                child: Container(
                  width: w(344.80),
                  height: h(110),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(20)),
                  ),
                ),
              ),
              Positioned(
                left: w(46.21),
                top: h(630),
                child: SizedBox(
                  width: w(145.18),
                  child: Text(
                    '30-day healthy Eating Challenge',
                    style: TextStyle(
                      color: const Color(0xFF212020),
                      fontSize: w(18),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: w(208.47),
                top: h(589),
                child: Container(
                  width: w(166.53),
                  height: h(114),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(w(27)),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/rempah.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // ===== Bottom Nav (fixed) =====
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
                      // ✅ 4 placeholder icon (ganti manual)
                      // HOME
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, AppRoutes.eat1);
                        },
                          child: SvgPicture.asset(
                              'assets/icons/logo-home2.svg',
                              width: w(25),
                              height: w(25),
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ))
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(context, AppRoutes.recomend);
                        },
                        child:SvgPicture.asset(
                        'assets/icons/icon-doc.svg',
                        width: w(25),
                        height: w(25),
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ))
                      ),
                      // DOC
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, AppRoutes.recomend);
                          },
                          child:SvgPicture.asset(
                              'assets/icons/logo-star.svg',
                              width: w(25),
                              height: w(25),
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ))
                      ),
                      // STAR
                      // PROFILE
                      GestureDetector(
                          onTap: (){
                            Navigator.pushNamed(context, AppRoutes.recomend);
                          },
                          child:SvgPicture.asset(
                              'assets/icons/logo-profile2.svg',
                              width: w(25),
                              height: w(25),
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ))
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
