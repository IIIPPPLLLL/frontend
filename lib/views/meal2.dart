import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';
import '../service/api_service.dart';

class MealPlans2 extends StatefulWidget {
  const MealPlans2({super.key});

  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<MealPlans2> createState() => _MealPlans2State();
}

class _MealPlans2State extends State<MealPlans2> {
  // ================= STATE =================
  final List<String> selectedAllergies = [];
  final List<String> selectedFoods = [];

  bool _isLoadingMeals = true;
  List<Map<String, dynamic>> meals = [];

  // ================= INIT =================
  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  // ================= TOKEN =================
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ================= LOAD MEALS =================
  Future<void> _loadMeals() async {
    try {
      final token = await _getToken();
      if (token == null) return;

      final response = await ApiService.getMeals(token);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List<dynamic> data =
        decoded is Map ? decoded['data'] ?? [] : decoded;

        setState(() {
          meals = data.cast<Map<String, dynamic>>();
          _isLoadingMeals = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Load meals error: $e');
      _isLoadingMeals = false;
    }
  }

  // ================= SVG =================
  Widget svgIcon(String asset, double size) {
    return SvgPicture.asset(
      asset,
      width: size,
      height: size,
      colorFilter:
      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sx = size.width / MealPlans2._designW;
    final sy = size.height / MealPlans2._designH;

    double w(double v) => v * sx;
    double h(double v) => v * sy;

    final canContinue =
        selectedAllergies.isNotEmpty || selectedFoods.isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Stack(
          children: [
            // ================= CONTENT =================
            Positioned.fill(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(w(24), h(20), w(24), h(90)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== BACK + TITLE =====
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, AppRoutes.meal),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: w(20),
                          ),
                        ),
                        SizedBox(width: w(12)),
                        Text(
                          'Meal',
                          style: TextStyle(
                            color: const Color(0xFF588D6E),
                            fontSize: w(25),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: h(18)),

                    // ===== TOP TAB NAVBAR =====
                    Container(
                      height: h(42),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(w(30)),
                      ),
                      child: Row(
                        children: [
                          // MEAL PLANS (ACTIVE)
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F163),
                                borderRadius:
                                BorderRadius.circular(w(30)),
                              ),
                              child: Text(
                                'Meal Plans',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w(14),
                                ),
                              ),
                            ),
                          ),

                          // RECOMMENDED
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.meal3,
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Recommended',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: w(14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h(24)),

                    // ===== ALLERGIES =====
                    _sectionTitle('Allergies', w),
                    _allergyOptions(w),

                    SizedBox(height: h(24)),

                    // ===== FOOD PREFERRED =====
                    _sectionTitle('Food Preferred', w),

                    SizedBox(height: h(12)),

                    _isLoadingMeals
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                      height: h(320),
                      child: ListView.builder(
                        itemCount: meals.length,
                        itemBuilder: (context, index) {
                          final meal = meals[index];
                          final name = meal['name'] ?? '';
                          final category = meal['category'] ?? '';
                          final calories =
                              meal['calories']?.toString() ?? '-';
                          final image = meal['image_url'];

                          final selected =
                          selectedFoods.contains(name);

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selected
                                    ? selectedFoods.remove(name)
                                    : selectedFoods.add(name);
                              });
                            },
                            child: Container(
                              margin:
                              EdgeInsets.only(bottom: h(10)),
                              padding: EdgeInsets.all(w(12)),
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFE2F163)
                                    .withOpacity(0.9)
                                    : Colors.white
                                    .withOpacity(0.08),
                                borderRadius:
                                BorderRadius.circular(w(12)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: w(60),
                                    height: w(60),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(w(8)),
                                      image: image != null
                                          ? DecorationImage(
                                        image:
                                        NetworkImage(image),
                                        fit: BoxFit.cover,
                                      )
                                          : null,
                                      color: Colors.black26,
                                    ),
                                  ),
                                  SizedBox(width: w(12)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          name,
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.black
                                                : Colors.white,
                                            fontWeight:
                                            FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          category,
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.black54
                                                : Colors.white70,
                                            fontSize: w(12),
                                          ),
                                        ),
                                        Text(
                                          '$calories kcal',
                                          style: TextStyle(
                                            color: selected
                                                ? Colors.black54
                                                : Colors.white70,
                                            fontSize: w(12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: h(28)),

                    // ===== CONTINUE =====
                    Center(
                      child: GestureDetector(
                        onTap: canContinue
                            ? () async {
                          final token = await _getToken();
                          if (token == null) return;

                          final response =
                          await ApiService.foodPreferences(
                            token: token,
                            allergies:
                            selectedAllergies.contains('None')
                                ? []
                                : selectedAllergies,
                            preferredFoods: selectedFoods,
                          );

                          if (response.statusCode == 200 ||
                              response.statusCode == 201) {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.meal3,
                            );
                          }
                        }
                            : null,
                        child: Opacity(
                          opacity: canContinue ? 1 : 0.5,
                          child: Container(
                            width: w(220),
                            height: h(44),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(w(100)),
                              border:
                              Border.all(color: Colors.white),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                decoration:
                                TextDecoration.underline,
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

            // ================= BOTTOM NAVBAR =================
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
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.home),
                      child: svgIcon(
                          'assets/icons/logo-home2.svg', w(26)),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.tracking),
                      child: svgIcon(
                          'assets/icons/icon-doc.svg', w(26)),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.home),
                      child: svgIcon(
                          'assets/icons/logo-star.svg', w(26)),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.chatbot),
                      child: svgIcon(
                          'assets/icons/logo-profile2.svg', w(26)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= ALLERGY OPTIONS =================
  Widget _allergyOptions(double Function(double) w) {
    final options = ['None', 'Nuts', 'Dairy', 'Shellfish', 'Eggs'];

    return Wrap(
      spacing: w(10),
      runSpacing: w(8),
      children: options.map((value) {
        final selected = selectedAllergies.contains(value);
        return FilterChip(
          label: Text(value),
          selected: selected,
          onSelected: (_) {
            setState(() {
              if (value == 'None') {
                selectedAllergies.clear();
                selectedAllergies.add('None');
              } else {
                selectedAllergies.remove('None');
                selected
                    ? selectedAllergies.remove(value)
                    : selectedAllergies.add(value);
              }
            });
          },
          selectedColor: const Color(0xFFE2F163),
          labelStyle: TextStyle(
            color: selected ? Colors.black : Colors.white,
          ),
          backgroundColor: Colors.white.withOpacity(0.1),
        );
      }).toList(),
    );
  }
}

// ================= HELPER =================
Widget _sectionTitle(String text, double Function(double) w) => Padding(
  padding: const EdgeInsets.only(bottom: 6),
  child: Text(
    text,
    style: TextStyle(
      color: const Color(0xFFE2F163),
      fontSize: w(18),
      fontWeight: FontWeight.w600,
    ),
  ),
);
