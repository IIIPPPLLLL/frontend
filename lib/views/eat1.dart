import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class EatSchedule extends StatelessWidget {
  EatSchedule({super.key});

  static const double _designW = 393;
  static const double _designH = 852;

  // Controller untuk text field (DIKOSONGKAN)
  final TextEditingController _breakfastController = TextEditingController();
  final TextEditingController _lunchController = TextEditingController();
  final TextEditingController _dinnerController = TextEditingController();
  final TextEditingController _snackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sx = size.width / _designW;
    final sy = size.height / _designH;

    double w(double v) => v * sx;
    double h(double v) => v * sy;

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

              // Back button (SUDAH ADA)
              Positioned(
                left: w(35),
                top: h(62),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgPicture.asset(
                    'assets/icons/back-icon.svg',
                    width: w(24),
                    height: w(24),
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF588D6E),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),

              // Title
              Positioned(
                left: w(80),
                top: h(62),
                child: Text(
                  'Create Schedule',
                  style: TextStyle(
                    color: const Color(0xFF588D6E),
                    fontSize: w(20),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Tabs
              Positioned(
                left: w(35),
                top: h(117),
                child: Container(
                  width: w(157),
                  height: h(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(38)),
                  ),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Eat Schedule',
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
                top: h(117),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.eat2);
                  },
                  child: Container(
                    width: w(157),
                    height: h(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F163),
                      borderRadius: BorderRadius.circular(w(38)),
                    ),
                    child: Center(
                      child: Text(
                        'Shopping List',
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
              ),

              // Meal Times
              Positioned(
                left: w(41),
                top: h(189),
                child: Text(
                  'Breakfast',
                  style: TextStyle(
                    color: const Color(0xFF588D6E),
                    fontSize: w(18),
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Positioned(
                left: w(307),
                top: h(189),
                child: Container(
                  width: w(54),
                  height: h(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '07:00',
                      style: TextStyle(
                        color: const Color(0xB2391713),
                        fontSize: w(10),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: w(41),
                top: h(211),
                child: Container(
                  width: w(322),
                  height: h(45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(15)),
                    child: TextField(
                      controller: _breakfastController,
                      style: TextStyle(
                        color: const Color(0xFF391713),
                        fontSize: w(16),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ex(Delights with yogurt, Milk)',
                        hintStyle: TextStyle(
                          color: const Color(0x4C391713),
                          fontSize: w(16),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Lunch
              Positioned(
                left: w(41),
                top: h(288),
                child: Text(
                  'Lunch',
                  style: TextStyle(
                    color: const Color(0xFF588D6E),
                    fontSize: w(18),
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Positioned(
                left: w(308),
                top: h(287),
                child: Container(
                  width: w(54),
                  height: h(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '12:30',
                      style: TextStyle(
                        color: const Color(0xB2391713),
                        fontSize: w(10),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: w(41),
                top: h(311),
                child: Container(
                  width: w(322),
                  height: h(45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(15)),
                    child: TextField(
                      controller: _lunchController,
                      style: TextStyle(
                        color: const Color(0xFF391713),
                        fontSize: w(16),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ex(Spinach Cromboloni, Water)',
                        hintStyle: TextStyle(
                          color: const Color(0x4C391713),
                          fontSize: w(16),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Dinner
              Positioned(
                left: w(41),
                top: h(392),
                child: Text(
                  'Dinner',
                  style: TextStyle(
                    color: const Color(0xFF588D6E),
                    fontSize: w(18),
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Positioned(
                left: w(309),
                top: h(388),
                child: Container(
                  width: w(54),
                  height: h(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '19:30',
                      style: TextStyle(
                        color: const Color(0xB2391713),
                        fontSize: w(10),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: w(41),
                top: h(415),
                child: Container(
                  width: w(322),
                  height: h(45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(15)),
                    child: TextField(
                      controller: _dinnerController,
                      style: TextStyle(
                        color: const Color(0xFF391713),
                        fontSize: w(16),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ex(Baked Salmon)',
                        hintStyle: TextStyle(
                          color: const Color(0x4C391713),
                          fontSize: w(16),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Snack
              Positioned(
                left: w(41),
                top: h(502),
                child: Text(
                  'Snack',
                  style: TextStyle(
                    color: const Color(0xFF588D6E),
                    fontSize: w(18),
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Positioned(
                left: w(308),
                top: h(502),
                child: Container(
                  width: w(54),
                  height: h(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '15:40',
                      style: TextStyle(
                        color: const Color(0xB2391713),
                        fontSize: w(10),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: w(41),
                top: h(525),
                child: Container(
                  width: w(322),
                  height: h(45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(15)),
                    border: Border.all(
                      color: const Color(0xFFE9F6FE),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: w(15)),
                    child: TextField(
                      controller: _snackController,
                      style: TextStyle(
                        color: const Color(0xFF391713),
                        fontSize: w(16),
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ex(Yogurt)',
                        hintStyle: TextStyle(
                          color: const Color(0x4C391713),
                          fontSize: w(16),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Save Schedule Button
              Positioned(
                left: w(106),
                top: h(630),
                child: GestureDetector(
                  onTap: () {
                    // Aksi ketika tombol ditekan
                    final scheduleData = {
                      'breakfast': _breakfastController.text.isNotEmpty
                          ? _breakfastController.text
                          : 'Delights with yogurt, Milk',
                      'lunch': _lunchController.text.isNotEmpty
                          ? _lunchController.text
                          : 'Spinach Cromboloni, Water',
                      'dinner': _dinnerController.text.isNotEmpty
                          ? _dinnerController.text
                          : 'Baked Salmon',
                      'snack': _snackController.text.isNotEmpty
                          ? _snackController.text
                          : 'Yogurt',
                    };

                    // Navigate ke halaman success atau kembali
                    Navigator.pushNamed(
                      context,
                      AppRoutes.home,
                      arguments: scheduleData,
                    );
                  },
                  child: Container(
                    width: w(178.56),
                    height: h(44),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(w(100)),
                      border: Border.all(
                        color: Colors.white,
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Save Schedule',
                        textAlign: TextAlign.center,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}