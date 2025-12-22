import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class ProgressTracking extends StatelessWidget {
  const ProgressTracking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Progress Tracking',
                style: TextStyle(
                  color: Color(0xFF588D6E),
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2F163),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Workout Log',
                        style: TextStyle(
                          color: Color(0xFF232222),
                          fontSize: 16,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.workout),
                    child: Container(
                      width: 160,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Text(
                          'Charts',
                          style: TextStyle(
                            color: Color(0xFF040306),
                            fontSize: 16,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
              const Text(
                'My Progress',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'January 12th',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 25,
                  fontFamily: 'League Spartan',
                ),
              ),

              const SizedBox(height: 25),
              const Text(
                'Steps',
                style: TextStyle(
                  color: Color(0xFF588D6E),
                  fontSize: 20,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StepNumber('170'),
                  _StepNumber('165'),
                  _StepNumber('155'),
                  _StepNumber('150'),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _Month('Jan'),
                  _Month('Feb'),
                  _Month('Mar'),
                  _Month('Apr'),
                ],
              ),

              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      _WorkoutLog('Thu', '14', '3,679', '1hr 40m'),
                      SizedBox(height: 15),
                      _WorkoutLog('Wed', '20', '5,789', '1hr 20m'),
                      SizedBox(height: 15),
                      _WorkoutLog('Sat', '22', '1,859', '1hr 10m'),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ================= NAVBAR SVG =================
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            height: 59,
            color: const Color(0xFF588D6E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                  child: SvgPicture.asset(
                    'assets/icons/logo-home2.svg',
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.tracking),
                  child: SvgPicture.asset(
                    'assets/icons/icon-doc.svg',
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                  child: SvgPicture.asset(
                    'assets/icons/logo-star.svg',
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                  child: SvgPicture.asset(
                    'assets/icons/logo-profile2.svg',
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= WIDGET KECIL ================= */

class _StepNumber extends StatelessWidget {
  final String number;
  const _StepNumber(this.number);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          number,
          style: const TextStyle(
            color: Color(0xFF232222),
            fontSize: 22,
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _Month extends StatelessWidget {
  final String month;
  const _Month(this.month);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Center(
        child: Text(
          month,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
            fontFamily: 'League Spartan',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _WorkoutLog extends StatelessWidget {
  final String day, date, steps, duration;
  const _WorkoutLog(this.day, this.date, this.steps, this.duration);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(day,
                  style: const TextStyle(
                    color: Color(0xFF588D6E),
                    fontSize: 18,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: 5),
              Text(date,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Steps',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontFamily: 'League Spartan',
                  )),
              const SizedBox(height: 5),
              Text(steps,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Duration',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontFamily: 'League Spartan',
                  )),
              const SizedBox(height: 5),
              Text(duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
