import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class Notification1 extends StatelessWidget {
  const Notification1({super.key});

  // biar w()/h() jalan (nyamain pola figma)
  static const double _designW = 393;
  static const double _designH = 852;

  void safeBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sx = size.width / _designW;
    final sy = size.height / _designH;

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
            color: Colors.white.withOpacity(0.10),
            borderRadius: BorderRadius.circular(w(6)),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== HEADER =====
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => safeBack(context),
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              color: Colors.white.withOpacity(0.10),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                            color: Color(0xFF588D6E),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    // ===== REMINDERS TAB =====
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      height: 34,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F163),
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: const Center(
                        child: Text(
                          'Reminders',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF232222),
                            fontSize: 17,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w500,
                            height: 1.18,
                            letterSpacing: -0.09,
                          ),
                        ),
                      ),
                    ),

                    // ===== TODAY =====
                    const SizedBox(height: 18),
                    const Text(
                      'Today',
                      style: TextStyle(
                        color: Color(0xFFE2F163),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildNotificationItem(
                      iconColor: const Color(0xFF34C759),
                      title: 'New workout is Available',
                      time: 'June 10 - 10:00 AM',
                      showSmallCircle: false,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationItem(
                      iconColor: const Color(0xFFE2F163),
                      title: 'Don\'t forget to drink water',
                      time: 'June 10 - 8:00 AM',
                      showSmallCircle: true,
                    ),

                    // ===== YESTERDAY =====
                    const SizedBox(height: 20),
                    const Text(
                      'Yesterday',
                      style: TextStyle(
                        color: Color(0xFFE2F163),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildNotificationItem(
                      iconColor: const Color(0xFFE2F163),
                      title: 'Upper Body Workout Completed!',
                      time: 'June 09 - 6:00 pM',
                      showSmallCircle: true,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationItem(
                      iconColor: const Color(0xFF34C759),
                      title: 'Remember Your Exercise Session',
                      time: 'June 09 - 3:00 pM',
                      showSmallCircle: false,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationItem(
                      iconColor: const Color(0xFF34C759),
                      title: 'new Article & Tip posted!',
                      time: 'June 09 - 11:00 aM',
                      showSmallCircle: false,
                    ),

                    // ===== MAY 29 =====
                    const SizedBox(height: 20),
                    const Text(
                      'May 29 - 20XX',
                      style: TextStyle(
                        color: Color(0xFFE2F163),
                        fontSize: 12,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildNotificationItem(
                      iconColor: const Color(0xFF34C759),
                      title: 'You started a new challenge!',
                      time: 'May 29 - 9:00 AM',
                      showSmallCircle: false,
                    ),
                    const SizedBox(height: 12),
                    _buildNotificationItem(
                      iconColor: const Color(0xFF34C759),
                      title: 'New House training ideas!',
                      time: 'May 29 - 8:20 AM',
                      showSmallCircle: false,
                    ),

                    // Space for bottom navbar
                    const SizedBox(height: 92),
                  ],
                ),
              ),
            ),

            // ✅ NAVBAR (DIGANTI SESUAI SNIPPET KAMU)
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
    );
  }

  Widget _buildNotificationItem({
    required Color iconColor,
    required String title,
    required String time,
    required bool showSmallCircle,
  }) {
    return Container(
      width: double.infinity,
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(36),
      ),
      child: Row(
        children: [
          // Icon Container
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.notifications,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              if (showSmallCircle)
                Positioned(
                  left: -2,
                  top: 2,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB3A0FF),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF232222),
                    fontSize: 13,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  time,
                  style: const TextStyle(
                    color: Color(0xFF588D6E),
                    fontSize: 12,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
