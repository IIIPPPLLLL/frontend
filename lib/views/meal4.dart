import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class MealPlans4 extends StatefulWidget {
  const MealPlans4({super.key});

  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<MealPlans4> createState() => _MealPlans4State();
}

class _MealPlans4State extends State<MealPlans4> {
  int selectedIndex = 2;

  // ✅ state untuk favorit (star) per card
  final Set<int> starredIndexes = <int>{};

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sx = size.width / MealPlans4._designW;
    final sy = size.height / MealPlans4._designH;

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

    final cards = [
      {
        "title": "Delights with\nGreek yogurt",
        "minutes": "6 Minutes",
        "cal": "200 Cal",
        "img": "assets/images/omlet.png",
      },
      {
        "title": "Spinach and\nTomato Omelette",
        "minutes": "10 Minutes",
        "cal": "220 Cal",
        "img": "assets/images/toast.png",
      },
      {
        "title": "Avocado And\nEgg Toast",
        "minutes": "15 Minutes",
        "cal": "150 Cal",
        "img": "assets/images/fruits.png",
      },
      {
        "title": "Protein Shake\nWith Fruits",
        "minutes": "9 Minutes",
        "cal": "180 Cal",
        "img": "assets/images/yogurt.png",
      },
    ];

    void toggleStar(int index) {
      setState(() {
        if (starredIndexes.contains(index)) {
          starredIndexes.remove(index);
        } else {
          starredIndexes.add(index);
        }
      });
    }

    Widget mealCard(int index) {
      final isSelected = selectedIndex == index;
      final isStarred = starredIndexes.contains(index);
      final data = cards[index];

      return Padding(
        padding: EdgeInsets.only(bottom: h(14)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // radio
            GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: Container(
                width: w(20),
                height: w(20),
                decoration: ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: w(1), color: const Color(0xFF896CFE)),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: w(12),
                    height: w(12),
                    decoration: ShapeDecoration(
                      color: isSelected ? const Color(0xFFE2F163) : Colors.transparent,
                      shape: OvalBorder(
                        side: BorderSide(width: w(1), color: const Color(0xFF896CFE)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: w(10)),

            // card (tap area -> select)
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => selectedIndex = index),
                child: Container(
                  height: h(110),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(20)),
                  ),
                  child: Stack(
                    children: [
                      // image kanan
                      Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(w(20)),
                          child: Image.asset(
                            data["img"] as String,
                            width: w(140),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      // isi kiri
                      Padding(
                        padding: EdgeInsets.fromLTRB(w(16), h(14), w(150), h(14)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data["title"] as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: w(20),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                height: 1.05,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Container(
                                  width: w(9),
                                  height: w(9),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF212020).withOpacity(0.25),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: w(6)),
                                Expanded(
                                  child: Text(
                                    data["minutes"] as String,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.black, // ✅ minutes hitam
                                      fontSize: w(12),
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                SizedBox(width: w(10)),
                                Container(
                                  width: w(7),
                                  height: w(9),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF212020).withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(w(2)),
                                  ),
                                ),
                                SizedBox(width: w(6)),
                                Text(
                                  data["cal"] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.black,
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

                      // ✅ STAR: bisa ditap, toggle kuning/putih
                      Positioned(
                        right: w(10),
                        top: h(10),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => toggleStar(index),
                          child: SizedBox(
                            width: w(28),
                            height: w(28),
                            child: Center(
                              child: svgPlaceholder(
                                assetPath: 'assets/icons/logo-star.svg',
                                width: w(16),
                                height: w(16),
                                color: isStarred
                                    ? const Color(0xFFE2F163)
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF212020),

      // navbar fixed bawah
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
              SizedBox(height: h(10)),

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
                    'Meal plans',
                    style: TextStyle(
                      color: const Color(0xFF588D6E),
                      fontSize: w(20),
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h(18)),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: h(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Breakfast plan for you',
                        style: TextStyle(
                          color: const Color(0xFFE2F163),
                          fontSize: w(20),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: h(6)),
                      SizedBox(
                        width: w(330),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w(14),
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w300,
                            height: 1.1,
                          ),
                        ),
                      ),
                      SizedBox(height: h(16)),

                      mealCard(0),
                      mealCard(1),
                      mealCard(2),
                      mealCard(3),

                      SizedBox(height: h(10)),

                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.meal5,
                              arguments: {
                                "selectedIndex": selectedIndex,
                                "selectedMeal": cards[selectedIndex],
                                "starredIndexes": starredIndexes.toList(),
                              },
                            );
                          },
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
                              'See Recipe',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: w(18),
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: h(20)),
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
