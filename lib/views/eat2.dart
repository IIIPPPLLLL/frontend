import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class EatSchedule2 extends StatelessWidget {
  const EatSchedule2({super.key});

  @override
  Widget build(BuildContext context) {
    // Kontroller untuk TextField
    final fruitsController = TextEditingController();
    final proteinsController = TextEditingController();
    final groceriesController = TextEditingController();
    final snackController = TextEditingController();
    final dateController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Back button dan title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Create Schedule',
                      style: TextStyle(
                        color: Color(0xFF588D6E),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Tab selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.eat1);
                      },
                      child: Container(
                        width: 157,
                        height: 32,
                        padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 6),
                        decoration: ShapeDecoration(
                          color: const Color(0xFFE2F163),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Eat Schedule',
                              style: TextStyle(
                                color: const Color(0xFF232222),
                                fontSize: (17),
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                                height: 1.18,
                                letterSpacing: -0.09,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.eat2);
                      },
                      child: Container(
                        width: 157,
                        height: 32,
                        padding: const EdgeInsets.only(top: 5, left: 12, right: 12, bottom: 6),
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(38),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Shopping List',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF040306),
                                fontSize: 17,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w400,
                                height: 1.18,
                                letterSpacing: -0.09,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Meal Type
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Breakfast',
                    style: TextStyle(
                      color: Color(0xFF212020),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Form Input Fields
                // Fruits & Vegetables
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fruits & Vegetables',
                      style: TextStyle(
                        color: Color(0xFF588D6E),
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE9F6FE),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: TextField(
                        controller: fruitsController,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xFF391713),
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: 'ex(spinach,apples,carrots)',
                          hintStyle: TextStyle(
                            color: Color(0x4C391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Proteins
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Proteins',
                      style: TextStyle(
                        color: Color(0xFF588D6E),
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE9F6FE),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: TextField(
                        controller: proteinsController,
                        style: const TextStyle(
                          color: Color(0xFF391713),
                          fontSize: 20,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: 'ex(chicken,tofu,beans)',
                          hintStyle: TextStyle(
                            color: Color(0x4C391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Groceries
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Groceries',
                      style: TextStyle(
                        color: Color(0xFF588D6E),
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE9F6FE),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: TextField(
                        controller: groceriesController,
                        style: const TextStyle(
                          color: Color(0xFF391713),
                          fontSize: 20,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: 'ex(rice,cereals,spices)',
                          hintStyle: TextStyle(
                            color: Color(0x4C391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Snack
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Snack',
                      style: TextStyle(
                        color: Color(0xFF588D6E),
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE9F6FE),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: TextField(
                        controller: snackController,
                        style: const TextStyle(
                          color: Color(0xFF391713),
                          fontSize: 20,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: 'ex(nuts,yogurt)',
                          hintStyle: TextStyle(
                            color: Color(0x4C391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Date',
                      style: TextStyle(
                        color: Color(0xFF588D6E),
                        fontSize: 18,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 1,
                            color: Color(0xFFE9F6FE),
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 15),
                          Container(
                            width: 23,
                            height: 22,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Color(0xFF588D6E),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: dateController,
                              style: const TextStyle(
                                color: Color(0xFF391713),
                                fontSize: 16,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: '20/12/2024',
                                hintStyle: TextStyle(
                                  color: Color(0xB2391713),
                                  fontSize: 16,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              onTap: () {
                                // Date picker bisa ditambahkan di sini
                                dateController.text = '20/12/2024';
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Save Schedule Button
                GestureDetector(
                  onTap: () {
                    // Simpan data schedule
                    final scheduleData = {
                      'fruits': fruitsController.text,
                      'proteins': proteinsController.text,
                      'groceries': groceriesController.text,
                      'snack': snackController.text,
                      'date': dateController.text,
                    };
                    print('Schedule saved: $scheduleData');

                    // Navigasi ke halaman lain setelah save
                    Navigator.pushNamed(context, AppRoutes.home);
                  },
                  child: Container(
                    width: 178.56,
                    height: 44,
                    decoration: ShapeDecoration(
                      color: Colors.white.withOpacity(0.09),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 0.50, color: Colors.white),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Save Schedule',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}