import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/app_routes.dart';
import '../service/api_service.dart';
import 'dart:convert';

class WorkoutLogs extends StatefulWidget {
  const WorkoutLogs({super.key});

  @override
  State<WorkoutLogs> createState() => _WorkoutLogsState();
}

class _WorkoutLogsState extends State<WorkoutLogs> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<String?> _getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  Future<void> _loadProfileData() async {
    print('🔄 === LOADING PROFILE DATA FOR WORKOUT LOGS ===');

    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print('❌ Token is null');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Token tidak ditemukan. Silakan login ulang.';
          _profileData = {
            'username': 'Max',
            'age': '28',
            'weight': '75',
            'height': '165',
          };
        });
        return;
      }

      print('🚀 Calling ApiService.profile()...');
      final response = await ApiService.profile(token);

      print('📡 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('✅ Success 200! Parsing JSON...');
        try {
          final data = jsonDecode(response.body);
          print('✅ JSON parsed successfully');

          // Extract data from the API response structure
          if (data.containsKey('data') && data['data'] is Map) {
            final userData = data['data'] as Map<String, dynamic>;

            // Extract health profile
            Map<String, dynamic>? healthProfile;
            if (userData.containsKey('health_profile') &&
                userData['health_profile'] is Map) {
              healthProfile = userData['health_profile'] as Map<String, dynamic>;
            }

            setState(() {
              _profileData = {
                'username': userData['username']?.toString() ?? 'User',
                'age': userData['age']?.toString() ?? '28',
                'weight': healthProfile?['weight']?.toString() ?? '75',
                'height': healthProfile?['height']?.toString() ?? '165',
              };
              _isLoading = false;
            });

            // Print data to console for debugging
            print('✅ Workout Logs Profile Data:');
            print('   👤 Username: ${_profileData!['username']}');
            print('   🎂 Age: ${_profileData!['age']}');
            print('   ⚖️ Weight: ${_profileData!['weight']}');
            print('   📏 Height: ${_profileData!['height']}');
          } else {
            throw Exception('Data structure not found');
          }
        } catch (e) {
          print('❌ JSON Parse Error: $e');
          setState(() {
            _isLoading = false;
            _errorMessage = 'Failed to parse profile data: $e';
            _profileData = {
              'username': 'Max',
              'age': '28',
              'weight': '75',
              'height': '165',
            };
          });
        }
      } else if (response.statusCode == 401) {
        print('❌ 401 Unauthorized');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Session expired. Please login again.';
          _profileData = {
            'username': 'Max',
            'age': '28',
            'weight': '75',
            'height': '165',
          };
        });
      } else {
        print('❌ Other error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load profile: ${response.statusCode}';
          _profileData = {
            'username': 'Max',
            'age': '28',
            'weight': '75',
            'height': '165',
          };
        });
      }
    } catch (e) {
      print('❌ Exception: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Network error: ${e.toString()}';
        _profileData = {
          'username': 'Max',
          'age': '28',
          'weight': '75',
          'height': '165',
        };
      });
    }

    print('=== END LOADING ===\n');
  }

  Future<void> _retryLoadProfile() async {
    await _loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Column(
          children: [
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

                    if (_errorMessage != null)
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.red, width: 1),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.error_outline,
                                    color: Colors.red, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    _errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.red, size: 20),
                                  onPressed: _retryLoadProfile,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    _isLoading
                        ? _buildProfileLoading()
                        : _buildProfileRow(),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: _SegmentButton(
                            label: 'Workout Log',
                            isActive: false,
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
                    const _WeekdayChips(),
                    const SizedBox(height: 12),
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

            _BottomNav(
              currentIndex: 1,
              onTap: (i) {
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
                    Navigator.pushNamed(context, AppRoutes.chatbot);
                    break;
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileLoading() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 22,
                color: Colors.grey[800],
                margin: const EdgeInsets.only(bottom: 6),
              ),
              Container(
                width: 80,
                height: 18,
                color: Colors.grey[800],
                margin: const EdgeInsets.only(bottom: 14),
              ),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 40,
                    color: Colors.grey[800],
                    margin: const EdgeInsets.only(right: 22),
                  ),
                  Container(
                    width: 60,
                    height: 40,
                    color: Colors.grey[800],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 86,
          height: 86,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileRow() {
    // Extract values with fallbacks
    final username = _profileData?['username']?.toString() ?? 'Max';
    final age = _profileData?['age']?.toString() ?? '28';
    final weight = _profileData?['weight']?.toString() ?? '75';
    final height = _profileData?['height']?.toString() ?? '165';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _ProfileInfo(
            username: username,
            age: age,
            weight: weight,
            height: height,
          ),
        ),
        const SizedBox(width: 12),
        const _AvatarPlaceholder(),
      ],
    );
  }
}

// =====================
// Widgets
// =====================

class _ProfileInfo extends StatelessWidget {
  final String username;
  final String age;
  final String weight;
  final String height;

  const _ProfileInfo({
    required this.username,
    required this.age,
    required this.weight,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    // Format berat dan tinggi - tambahkan satuan jika belum ada
    String formattedWeight = weight;
    if (!weight.toLowerCase().contains('kg') &&
        weight.isNotEmpty &&
        weight != 'Not set') {
      formattedWeight = '$weight Kg';
    }

    String formattedHeight = height;
    if (!height.toLowerCase().contains('cm') &&
        height.isNotEmpty &&
        height != 'Not set') {
      formattedHeight = '$height CM';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Age:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' $age',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            _MetricBlock(
              value: formattedWeight,
              label: 'Weight',
            ),
            const SizedBox(width: 22),
            _MetricBlock(
              value: formattedHeight,
              label: 'Height',
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
  const _AvatarPlaceholder();

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
      ),
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