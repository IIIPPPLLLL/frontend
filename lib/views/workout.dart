import 'package:flutter/material.dart';
import '../routes/app_routes.dart';

class WorkoutLogs extends StatelessWidget {
  const WorkoutLogs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Column(
          children: [
            // ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header (Back + Title)
                    Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(10),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios_new,
                                size: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Progress Tracking',
                          style: TextStyle(
                            color: Color(0xFF588D6E),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Profile summary row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _ProfileInfo(),
                        ),
                        const SizedBox(width: 12),
                        _AvatarPlaceholder(),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Segmented buttons (Workout Log / Charts)
                    Row(
                      children: [
                        Expanded(
                          child: _SegmentButton(
                            label: 'Workout Log',
                            isActive: false,
                            // ROUTE for "Workout" button (Workout Log)
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.tracking);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _SegmentButton(
                            label: 'Charts',
                            isActive: true,
                            onTap: () {
                              // already here (Charts tab), keep it noop
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Choose Date + Month dropdown label
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Choose Date',
                            style: TextStyle(
                              color: Color(0xFFE2F163),
                              fontSize: 14,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // placeholder: open month picker later
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Month',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Weekday chips (MON..SUN)
                    const _WeekdayChips(),

                    const SizedBox(height: 12),

                    // Calendar box
                    const _CalendarCard(),

                    const SizedBox(height: 18),

                    const Text(
                      'Activities',
                      style: TextStyle(
                        color: Color(0xFFE2F163),
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Activity cards
                    const _ActivityCard(
                      kcal: '120 Kcal',
                      title: 'Upper Body Workout',
                      subtitle: 'June 09',
                      duration: '25 Mins',
                    ),
                    const SizedBox(height: 12),
                    const _ActivityCard(
                      kcal: '130 Kcal',
                      title: 'Pull out',
                      subtitle: 'April 15 - 4:00 PM',
                      duration: '30 Mins',
                    ),
                  ],
                ),
              ),
            ),

            // ===== BOTTOM NAVBAR =====
            _BottomNav(
              currentIndex: 1, // adjust to your tab index
              onTap: (i) {
                // ROUTES for navbar
                switch (i) {
                  case 0:
                    Navigator.pushNamed(context, AppRoutes.home);
                    break;
                  case 1:
                    Navigator.pushNamed(context, AppRoutes.tracking);
                    break;
                  case 2:
                    Navigator.pushNamed(context, AppRoutes.home);
                    break;
                  case 3:
                    Navigator.pushNamed(context, AppRoutes.profile);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =====================
// Widgets (clean + responsive)
// =====================

class _ProfileInfo extends StatelessWidget {
  const _ProfileInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Max',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 6),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Age:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' 28',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 14),
        Row(
          children: [
            _MetricBlock(
              value: '75 Kg',
              label: 'Weight',
            ),
            SizedBox(width: 22),
            _MetricBlock(
              value: '1.65 CM',
              label: 'height',
            ),
          ],
        ),
      ],
    );
  }
}

class _MetricBlock extends StatelessWidget {
  final String value;
  final String label;

  const _MetricBlock({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFE2F163),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'League Spartan',
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 86,
      height: 86,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.person, color: Colors.black54, size: 34),
      ), // placeholder (you will replace with image later)
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isActive ? const Color(0xFF34C759) : Colors.white;
    final fg = isActive ? const Color(0xFF080808) : const Color(0xFF232222);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(38),
      child: Container(
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(38),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontSize: 17,
            fontFamily: 'League Spartan',
            fontWeight: isActive ? FontWeight.w400 : FontWeight.w500,
            letterSpacing: -0.09,
            height: 1.18,
          ),
        ),
      ),
    );
  }
}

class _WeekdayChips extends StatelessWidget {
  const _WeekdayChips();

  @override
  Widget build(BuildContext context) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => Container(
          width: 40,
          height: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF588D6E),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            d,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'League Spartan',
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      )
          .toList(),
    );
  }
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context) {
    // hardcoded like figma (you can wire it later)
    final grid = <List<String>>[
      ['1', '2', '3', '4', '5', '6', '7'],
      ['8', '9', '10', '11', '12', '13', '14'],
      ['15', '16', '17', '18', '19', '20', '21'],
      ['22', '23', '24', '25', '26', '27', '28'],
      ['29', '30', '31', '', '', '', ''],
    ];
    const selected = '9';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2F163), width: 1),
      ),
      child: Column(
        children: grid.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: row.map((day) {
                final isEmpty = day.isEmpty;
                final isSelected = day == selected;

                Color textColor;
                if (isEmpty) {
                  textColor = Colors.transparent;
                } else if (isSelected) {
                  textColor = Colors.black;
                } else if (day == '1' ||
                    day == '2' ||
                    day == '3' ||
                    day == '4' ||
                    day == '5' ||
                    day == '6' ||
                    day == '7' ||
                    day == '14' ||
                    day == '21' ||
                    day == '28' ||
                    day == '29' ||
                    day == '30' ||
                    day == '31') {
                  textColor = Colors.black;
                } else {
                  textColor = const Color(0xFF896CFE);
                }

                return SizedBox(
                  width: 32,
                  child: Center(
                    child: isSelected
                        ? Container(
                      width: 22,
                      height: 22,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F163),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Text(
                        day,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                        : Text(
                      day.isEmpty ? '.' : day,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12,
                        fontFamily: 'League Spartan',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String kcal;
  final String title;
  final String subtitle;
  final String duration;

  const _ActivityCard({
    required this.kcal,
    required this.title,
    required this.subtitle,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      constraints: const BoxConstraints(minHeight: 70),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          // icon placeholder
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: Color(0xFF588D6E),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.fitness_center, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(width: 12),

          // left texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  kcal,
                  style: const TextStyle(
                    color: Color(0xFF212020),
                    fontSize: 12,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 2),
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
                const SizedBox(height: 2),
                Text(
                  subtitle,
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

          // right duration
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Duration',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.schedule, size: 16, color: Colors.black),
                  const SizedBox(width: 6),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Color(0xFF050505),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      decoration: const BoxDecoration(
        color: Color(0xFF588D6E),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF588D6E),
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Logs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Fav',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
