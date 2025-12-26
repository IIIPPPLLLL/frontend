import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';


class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfileHome> {
  Map<String, dynamic>? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    print('🔄 === LOADING PROFILE DATA ===');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('token');

      print('🔐 Token: ${_token != null ? "Available" : "NULL"}');

      if (_token == null) {
        print('❌ Token is null');
        setState(() {
          _errorMessage = 'Session expired. Please login again.';
          _isLoading = false;
        });
        return;
      }

      // Fetch profile data from API
      print('🚀 Calling ApiService.profile()...');
      final response = await ApiService.profile(_token!);

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body Length: ${response.body.length}');

      if (response.statusCode == 200) {
        print('✅ Success 200! Parsing JSON...');
        try {
          final data = jsonDecode(response.body);
          print('✅ JSON parsed successfully');

          setState(() {
            _userProfile = data;
            _isLoading = false;
          });

          // Print data to console
          _printProfileData(data);

        } catch (e) {
          print('❌ JSON Parse Error: $e');
          setState(() {
            _errorMessage = 'Failed to parse profile data: $e';
            _isLoading = false;
          });
        }

      } else if (response.statusCode == 401) {
        print('❌ 401 Unauthorized');
        setState(() {
          _errorMessage = 'Session expired. Please login again.';
          _isLoading = false;
        });
      } else if (response.statusCode == 404) {
        print('❌ 404 Endpoint not found');
        setState(() {
          _errorMessage = 'Profile endpoint not found (404)';
          _isLoading = false;
        });
      } else {
        print('❌ Other error: ${response.statusCode}');
        setState(() {
          _errorMessage = 'Failed to load profile: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Exception: $e');
      setState(() {
        _errorMessage = 'Network error: ${e.toString()}';
        _isLoading = false;
      });
    }

    print('=== END LOADING ===\n');
  }

  void _printProfileData(Map<String, dynamic> data) {
    print('\n📋 === USER PROFILE DATA ===');

    // Cek apakah ada key 'data'
    if (data.containsKey('data') && data['data'] is Map) {
      final userData = data['data'] as Map<String, dynamic>;

      print('👤 Username: ${userData['username'] ?? 'N/A'}');
      print('📧 Email: ${userData['email'] ?? 'N/A'}');
      print('🎂 Age: ${userData['age'] ?? 'N/A'}');
      print('🚻 Gender: ${userData['gender'] ?? 'N/A'}');
      print('🏃 Activity Level: ${userData['physical_activity_level'] ?? 'N/A'}');

      // Health profile
      if (userData.containsKey('health_profile') && userData['health_profile'] is Map) {
        final health = userData['health_profile'] as Map<String, dynamic>;
        print('📏 Height: ${health['height'] ?? 'N/A'} cm');
        print('⚖️ Weight: ${health['weight'] ?? 'N/A'} kg');
      }

      // Print semua data untuk debugging
      print('\n📊 Full response data:');
      userData.forEach((key, value) {
        print('   $key: $value (${value.runtimeType})');
      });
    } else {
      print('⚠️ Data not found in expected structure');
      print('📊 Available keys: ${data.keys.toList()}');
    }
    print('===========================\n');
  }

  String _getGenderDisplay(dynamic gender) {
    if (gender == null) return '';

    final genderStr = gender.toString().toLowerCase();
    if (genderStr == 'male' || genderStr == 'm' || genderStr == '1') {
      return 'Male';
    } else if (genderStr == 'female' || genderStr == 'f' || genderStr == '2') {
      return 'Female';
    } else {
      return gender.toString();
    }
  }

  String _getActivityLevelDisplay(dynamic activityLevel) {
    if (activityLevel == null) return '';

    final levelStr = activityLevel.toString().toLowerCase();
    if (levelStr.contains('beginner') || levelStr == '1' || levelStr == 'low') {
      return 'Beginner';
    } else if (levelStr.contains('intermediate') || levelStr == '2' || levelStr == 'medium') {
      return 'Intermediate';
    } else if (levelStr.contains('advance') || levelStr == '3' || levelStr == 'high') {
      return 'Advance';
    } else {
      return activityLevel.toString();
    }
  }

  Widget _buildProfileItem(String label, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF444444), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFAAAAAA),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : 'Not set',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: Column(
          children: [
            // AppBar Custom
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  // Back Button with text
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFE2F163),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: Color(0xFFE2F163),
                            fontSize: 18,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Spacer
                  const Spacer(),

                  // Title
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),

                  // Spacer untuk balance
                  const Spacer(),

                  // Placeholder untuk alignment
                  const SizedBox(width: 60),
                ],
              ),
            ),

            // Main Content dengan Expanded agar scrollable
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage != null
                  ? _buildErrorState()
                  : _userProfile != null
                  ? _buildProfileContent()
                  : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Color(0xFFE2F163),
          ),
          SizedBox(height: 20),
          Text(
            'Loading profile...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 60,
            ),
            const SizedBox(height: 20),
            Text(
              _errorMessage ?? 'Failed to load profile',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _loadProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE2F163),
                foregroundColor: const Color(0xFF232222),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Try Again',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Icon(
              Icons.person_outline,
              color: Colors.grey,
              size: 80,
            ),
            const SizedBox(height: 20),
            const Text(
              'No profile data available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _loadProfileData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE2F163),
                foregroundColor: const Color(0xFF232222),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Load Profile',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    // Extract main data from 'data' key
    final userData = _userProfile?['data'] as Map<String, dynamic>?;

    if (userData == null) {
      return _buildErrorState();
    }

    // Extract fields sesuai dengan data yang diterima dari backend
    final username = userData['username']?.toString() ?? '';
    final email = userData['email']?.toString() ?? '';
    final age = userData['age']?.toString() ?? '';
    final gender = userData['gender']?.toString();
    final activityLevel = userData['physical_activity_level']?.toString();

    // Extract health profile data
    final healthProfile = userData['health_profile'] as Map<String, dynamic>?;
    final height = healthProfile?['height']?.toString() ?? 'Not set';
    final weight = healthProfile?['weight']?.toString() ?? 'Not set';

    return Column(
      children: [
        // Scrollable content
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Icon
                Container(
                  width: 120,
                  height: 120,
                  margin: const EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2C2C2C),
                    border: Border.all(
                      color: const Color(0xFFE2F163),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Color(0xFFE2F163),
                    size: 60,
                  ),
                ),

                // Username
                _buildProfileItem(
                  'Username',
                  username,
                ),

                // Email
                _buildProfileItem(
                  'Email',
                  email,
                ),

                // Age
                _buildProfileItem(
                  'Age',
                  age,
                ),

                // Gender
                _buildProfileItem(
                  'Gender',
                  _getGenderDisplay(gender),
                ),

                // Activity Level
                _buildProfileItem(
                  'Activity Level',
                  _getActivityLevelDisplay(activityLevel),
                ),

                // Height
                _buildProfileItem(
                  'Height',
                  height == 'Not set' ? height : '$height cm',
                ),

                // Weight
                _buildProfileItem(
                  'Weight',
                  weight == 'Not set' ? weight : '$weight kg',
                ),

                // Spacing untuk scroll
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}