import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../routes/app_routes.dart';
import '../service/api_service.dart';

class MealPlans3 extends StatefulWidget {
  const MealPlans3({super.key});

  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<MealPlans3> createState() => _MealPlans3State();
}

class _MealPlans3State extends State<MealPlans3> {
  bool isLoading = true;
  List<Map<String, dynamic>> recommendations = [];
  int? expandedIndex;

  // ================= TOKEN =================
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ================= LOAD RECOMMENDATION =================
  Future<void> _loadRecommendations() async {
    final token = await _getToken();
    if (token == null) return;

    try {
      final response = await ApiService.getRecommendations(token);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List data = decoded['recommendations'] ?? [];

        setState(() {
          recommendations = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint('❌ Recommendation error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sx = size.width / MealPlans3._designW;
    final sy = size.height / MealPlans3._designH;

    double w(double v) => v * sx;
    double h(double v) => v * sy;

    Widget svgIcon(String asset, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: SvgPicture.asset(
          asset,
          width: w(26),
          height: w(26),
          colorFilter:
          const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Stack(
          children: [
            // ================= CONTENT =================
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.fromLTRB(w(20), h(20), w(20), h(90)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER =====
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
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
                          // MEAL PLANS
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.meal2,
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Meal Plans',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                    fontSize: w(14),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // RECOMMENDED (ACTIVE)
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE2F163),
                                borderRadius:
                                BorderRadius.circular(w(30)),
                              ),
                              child: Text(
                                'Recommended',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: w(14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: h(20)),

                    Text(
                      'Recommended Meals',
                      style: TextStyle(
                        color: const Color(0xFF588D6E),
                        fontSize: w(22),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Based on your food preferences',
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: h(16)),

                    // ===== LIST =====
                    Expanded(
                      child: isLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      )
                          : recommendations.isEmpty
                          ? const Center(
                        child: Text(
                          'Rekomendasi makanan belum tersedia',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                          : ListView.builder(
                        itemCount: recommendations.length,
                        itemBuilder: (context, index) {
                          return _mealCard(
                            recommendations[index],
                            index,
                            w,
                          );
                        },
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
                    svgIcon(
                      'assets/icons/logo-home2.svg',
                          () => Navigator.pushNamed(
                          context, AppRoutes.home),
                    ),
                    svgIcon(
                      'assets/icons/icon-doc.svg',
                          () => Navigator.pushNamed(
                          context, AppRoutes.tracking),
                    ),
                    svgIcon(
                      'assets/icons/logo-star.svg',
                          () => Navigator.pushNamed(
                          context, AppRoutes.home),
                    ),
                    svgIcon(
                      'assets/icons/logo-profile2.svg',
                          () => Navigator.pushNamed(
                          context, AppRoutes.chatbot),
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

  // ================= MEAL CARD =================
  Widget _mealCard(
      Map<String, dynamic> meal,
      int index,
      double Function(double) w,
      ) {
    final expanded = expandedIndex == index;
    final List ingredients = meal['ingredients'] ?? [];

    return GestureDetector(
      onTap: () {
        setState(() {
          expandedIndex = expanded ? null : index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: w(90),
                  height: w(90),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: meal['image_url'] != null
                        ? DecorationImage(
                      image: NetworkImage(meal['image_url']),
                      fit: BoxFit.cover,
                    )
                        : null,
                    color: Colors.black26,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal['name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        meal['description'] ??
                            meal['category'] ??
                            '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${meal['calories'] ?? '-'} kcal',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (expanded) ...[
              const SizedBox(height: 14),
              const Divider(color: Colors.white24),
              const SizedBox(height: 8),
              const Text(
                'Ingredients',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...ingredients.map(
                    (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '• $i',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
