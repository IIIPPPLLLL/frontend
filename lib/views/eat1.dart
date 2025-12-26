import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../routes/app_routes.dart';
import '../service/api_service.dart';

class EatSchedule extends StatefulWidget {
  const EatSchedule({super.key});

  @override
  State<EatSchedule> createState() => _EatScheduleState();
}

class _EatScheduleState extends State<EatSchedule> {
  // State untuk dropdown dan data
  String? selectedMealTime = 'Breakfast';
  Map<String, dynamic>? selectedMeal;
  List<Map<String, dynamic>> mealsList = [];
  bool isLoadingMeals = true;
  String? errorMessage;
  DateTime selectedDate = DateTime.now();

  // Controller untuk notes text field
  TextEditingController? _notesController;

  // State untuk existing schedules
  List<Map<String, dynamic>> _existingSchedules = [];
  bool _isLoadingSchedules = true;
  bool _showForm = true;

  // List pilihan waktu makan dengan icon
  final List<Map<String, dynamic>> mealTimes = [
    {'name': 'Breakfast', 'icon': Icons.breakfast_dining, 'color': Color(0xFFFFB74D)},
    {'name': 'Lunch', 'icon': Icons.lunch_dining, 'color': Color(0xFF4CAF50)},
    {'name': 'Dinner', 'icon': Icons.dinner_dining, 'color': Color(0xFF2196F3)},
    {'name': 'Snack', 'icon': Icons.cookie, 'color': Color(0xFF9C27B0)},
  ];

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
    _loadDataSequentially();
  }

  @override
  void dispose() {
    _notesController?.dispose();
    super.dispose();
  }

  Future<void> _loadDataSequentially() async {
    print('🔄 === START SEQUENTIAL DATA LOADING ===');
    try {
      await _loadMealsData();
      await _loadExistingSchedules();
    } catch (e) {
      print('❌ Error in sequential loading: $e');
    }
    print('✅ === END SEQUENTIAL DATA LOADING ===');
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

  Future<void> _loadMealsData() async {
    print('🔄 === LOADING MEALS DATA ===');
    try {
      setState(() {
        isLoadingMeals = true;
        errorMessage = null;
      });

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        print('❌ Token is null or empty');
        setState(() {
          isLoadingMeals = false;
          errorMessage = 'Token tidak ditemukan. Silakan login ulang.';
        });
        return;
      }

      print('🚀 Calling ApiService.getMeals()...');
      final response = await ApiService.getMeals(token);
      print('📡 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          final responseBody = response.body;
          if (responseBody.isEmpty) {
            throw Exception('Response body is empty');
          }

          final data = jsonDecode(responseBody);
          print('✅ JSON parsed successfully');

          List<dynamic> mealsData = [];
          if (data is Map) {
            final dataMap = data as Map;
            if (dataMap.containsKey('data') && dataMap['data'] is List) {
              mealsData = dataMap['data'] as List<dynamic>;
            } else if (dataMap.containsKey('meals') && dataMap['meals'] is List) {
              mealsData = dataMap['meals'] as List<dynamic>;
            } else if (dataMap.containsKey('items') && dataMap['items'] is List) {
              mealsData = dataMap['items'] as List<dynamic>;
            } else {
              for (var key in dataMap.keys) {
                final value = dataMap[key];
                if (value is List) {
                  mealsData = value;
                  break;
                }
              }
            }
          } else if (data is List) {
            mealsData = data;
          }

          if (mealsData.isEmpty) {
            print('⚠️ No meal data found in response');
            setState(() {
              isLoadingMeals = false;
              errorMessage = 'No meals available. Please add meals first.';
            });
            return;
          }

          print('📊 Processing ${mealsData.length} meal items');
          final processedMeals = <Map<String, dynamic>>[];

          for (var meal in mealsData) {
            try {
              if (meal is! Map) continue;
              final mealMap = meal as Map;

              String getValue(List<String> possibleKeys, String defaultValue) {
                for (var key in possibleKeys) {
                  if (mealMap.containsKey(key) &&
                      mealMap[key] != null &&
                      mealMap[key].toString().trim().isNotEmpty) {
                    return mealMap[key].toString();
                  }
                }
                return defaultValue;
              }

              String mealId = '';
              if (mealMap.containsKey('_id') && mealMap['_id'] != null) {
                final idValue = mealMap['_id'];
                if (idValue is Map && idValue.containsKey('\$oid')) {
                  mealId = idValue['\$oid'].toString();
                } else {
                  mealId = idValue.toString();
                }
              } else {
                mealId = getValue(['id', 'meal_id', 'food_id'], '');
              }

              final name = getValue(['name', 'meal_name', 'title'], 'Unknown Meal');
              final description = getValue(['description', 'desc', 'details'], '');
              final calories = getValue(['calories', 'calorie', 'energy', 'kcal'], '0');
              final category = getValue(['category', 'type', 'meal_type'], '');

              String? imageUrl;
              final imageKeys = ['image_url', 'image', 'photo', 'imageUrl'];
              for (var key in imageKeys) {
                if (mealMap.containsKey(key) &&
                    mealMap[key] != null &&
                    mealMap[key].toString().trim().isNotEmpty) {
                  imageUrl = mealMap[key].toString();
                  break;
                }
              }

              final mealObject = {
                'id': mealId,
                'name': name,
                'description': description,
                'calories': calories,
                'category': category,
                'image_url': imageUrl,
              };

              processedMeals.add(mealObject);
            } catch (e) {
              print('⚠️ Error processing meal: $e');
            }
          }

          setState(() {
            mealsList = processedMeals;
            if (mealsList.isNotEmpty) {
              selectedMeal = mealsList[0];
            }
            isLoadingMeals = false;
          });

          print('✅ Meals loaded successfully: ${mealsList.length} items');
        } catch (e) {
          print('❌ JSON Parse Error: $e');
          setState(() {
            isLoadingMeals = false;
            errorMessage = 'Failed to parse meals data: ${e.toString()}';
          });
        }
      } else if (response.statusCode == 401) {
        print('❌ 401 Unauthorized');
        setState(() {
          isLoadingMeals = false;
          errorMessage = 'Session expired. Please login again.';
        });
      } else {
        print('❌ Other error: ${response.statusCode}');
        setState(() {
          isLoadingMeals = false;
          errorMessage = 'Failed to load meals: ${response.statusCode}';
        });
      }
    } catch (e) {
      print('❌ Exception in _loadMealsData: $e');
      setState(() {
        isLoadingMeals = false;
        errorMessage = 'Network error: ${e.toString()}';
      });
    }
    print('=== END LOADING MEALS DATA ===\n');
  }

  Future<void> _loadExistingSchedules() async {
    print('🔄 === LOADING EXISTING SCHEDULES ===');
    try {
      setState(() {
        _isLoadingSchedules = true;
      });

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        print('❌ Token is null');
        setState(() {
          _isLoadingSchedules = false;
        });
        return;
      }

      print('📡 Calling ApiService.getEatSchedule()...');
      final response = await ApiService.getEatSchedule(token);
      print('📡 Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print('📋 Raw response data: $data');

          List<dynamic> schedulesData = [];
          if (data is Map && data.containsKey('data') && data['data'] is List) {
            schedulesData = data['data'] as List<dynamic>;
            print('✅ Found schedules in "data" key: ${schedulesData.length} items');
          } else if (data is List) {
            schedulesData = data;
            print('✅ Data is directly a List: ${schedulesData.length} items');
          } else if (data is Map && data.containsKey('schedules') && data['schedules'] is List) {
            schedulesData = data['schedules'] as List<dynamic>;
            print('✅ Found schedules in "schedules" key: ${schedulesData.length} items');
          }

          if (schedulesData.isEmpty) {
            print('⚠️ No schedules found');
            setState(() {
              _existingSchedules = [];
              _isLoadingSchedules = false;
            });
            return;
          }

          final processedSchedules = <Map<String, dynamic>>[];
          for (var schedule in schedulesData) {
            try {
              if (schedule is! Map) continue;
              final scheduleMap = schedule as Map;
              print('🔍 Processing schedule: $scheduleMap');

              // PERBAIKAN UTAMA: Ekstrak ID schedule dengan benar
              String scheduleId = '';

              // Coba ekstrak dari berbagai kemungkinan field
              if (scheduleMap['_id'] != null) {
                final idValue = scheduleMap['_id'];
                if (idValue is Map && idValue.containsKey('\$oid')) {
                  scheduleId = idValue['\$oid'].toString();
                  print('✅ Extracted ID from _id.\$oid: $scheduleId');
                } else {
                  scheduleId = idValue.toString();
                  print('✅ Extracted ID from _id: $scheduleId');
                }
              }

              // Coba field lain jika masih kosong
              if (scheduleId.isEmpty && scheduleMap['id'] != null) {
                scheduleId = scheduleMap['id'].toString();
                print('✅ Extracted ID from id: $scheduleId');
              }

              if (scheduleId.isEmpty && scheduleMap['schedule_id'] != null) {
                scheduleId = scheduleMap['schedule_id'].toString();
                print('✅ Extracted ID from schedule_id: $scheduleId');
              }

              if (scheduleId.isEmpty) {
                print('⚠️ Warning: Could not extract ID from schedule');
                // Skip schedule tanpa ID
                continue;
              }

              // Ekstrak meal_id
              String mealId = '';
              if (scheduleMap['meal_id'] != null) {
                final mealIdValue = scheduleMap['meal_id'];
                if (mealIdValue is Map && mealIdValue.containsKey('\$oid')) {
                  mealId = mealIdValue['\$oid'].toString();
                } else {
                  mealId = mealIdValue.toString();
                }
              }

              // Match meal data
              Map<String, dynamic> matchedMeal = {
                'id': '',
                'name': 'Unknown Meal',
                'calories': 'N/A',
                'category': 'Unknown',
                'image_url': null,
                'description': '',
              };

              if (mealId.isNotEmpty && mealsList.isNotEmpty) {
                for (var meal in mealsList) {
                  if (meal['id'].toString() == mealId) {
                    matchedMeal = Map<String, dynamic>.from(meal);
                    break;
                  }
                }
              }

              // Build schedule object dengan semua kemungkinan ID fields
              final scheduleObject = {
                'id': scheduleId,
                '_id': scheduleId,
                'schedule_id': scheduleId, // Tambah field alternatif
                'date': scheduleMap['date']?.toString() ?? '',
                'meal_time': scheduleMap['meal_time']?.toString() ?? 'Breakfast',
                'notes': scheduleMap['notes']?.toString() ?? '',
                'created_at': scheduleMap['created_at']?.toString() ?? '',
                'meal': matchedMeal,
                'meal_id': mealId,
                'raw_data': scheduleMap, // Simpan data mentah untuk debugging
              };

              processedSchedules.add(scheduleObject);
              print('✅ Added schedule with ID: $scheduleId');

            } catch (e) {
              print('⚠️ Error processing schedule: $e');
            }
          }

          setState(() {
            _existingSchedules = processedSchedules;
            _isLoadingSchedules = false;
          });

          print('✅ ${_existingSchedules.length} schedules loaded successfully');

          // Debug: Tampilkan semua schedule ID
          for (var schedule in _existingSchedules) {
            print('📋 Schedule - ID: ${schedule['id']}, Meal: ${schedule['meal']['name']}, Date: ${schedule['date']}');
          }

        } catch (e) {
          print('❌ JSON Parse Error: $e');
          setState(() {
            _isLoadingSchedules = false;
          });
        }
      } else {
        print('❌ Failed to load schedules: ${response.statusCode}');
        print('📡 Response body: ${response.body}');
        setState(() {
          _isLoadingSchedules = false;
        });
      }
    } catch (e) {
      print('❌ Exception loading schedules: $e');
      setState(() {
        _isLoadingSchedules = false;
      });
    }
  }

  Future<void> _saveSchedule() async {
    print('💾 === SAVING SCHEDULE ===');
    if (selectedMeal == null) {
      print('❌ No meal selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a meal'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final token = await _getToken();
      if (token == null || token.isEmpty) {
        print('❌ Token is null');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final scheduleData = {
        'date': '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
        'meal_time': selectedMealTime?.toLowerCase() ?? 'breakfast',
        'meal_id': selectedMeal!['id'],
        'notes': _notesController?.text ?? '',
      };

      print('📤 Sending schedule data: $scheduleData');
      final response = await ApiService.eatSchedule(token, scheduleData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Schedule saved successfully');
        setState(() {
          _notesController?.clear();
          selectedMealTime = 'Breakfast';
          selectedDate = DateTime.now();
        });

        await _loadExistingSchedules();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schedule saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('❌ Failed to save schedule: ${response.statusCode}');
        print('📡 Response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save schedule: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Exception saving schedule: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _deleteSchedule(int index) async {
    print('🗑️ === DELETING SCHEDULE ===');

    try {
      if (index < 0 || index >= _existingSchedules.length) {
        print('❌ Invalid index');
        return;
      }

      final schedule = _existingSchedules[index];
      print('🔍 Schedule data: $schedule');

      // ✅ SUMBER KEBENARAN TUNGGAL
      final String scheduleId = schedule['id']?.toString() ?? '';

      if (scheduleId.isEmpty) {
        print('❌ Schedule ID is EMPTY');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete schedule: Invalid ID'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print('✅ Using schedule ID: $scheduleId');

      // Konfirmasi user
      final confirm = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Delete Schedule'),
          content: Text(
            'Are you sure you want to delete ${schedule['meal_time']} '
                'on ${schedule['date']}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        ),
      ) ?? false;

      if (!confirm) {
        print('❌ User cancelled delete');
        return;
      }

      final token = await _getToken();
      if (token == null || token.isEmpty) {
        print('❌ Token missing');
        return;
      }

      print('🚀 Calling delete API with ID: $scheduleId');

      final response =
      await ApiService.deleteEatSchedule(token, scheduleId);

      print('📡 Status: ${response.statusCode}');
      print('📡 Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Delete success');

        setState(() {
          _existingSchedules.removeAt(index);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Schedule deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );

        await _loadExistingSchedules();
      } else {
        print('❌ Delete failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete (${response.statusCode})'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Exception: $e');
    }
  }


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xFF588D6E),
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF588D6E),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget _buildScheduleCard(int index, Map<String, dynamic> schedule) {
    final mealTime = schedule['meal_time'] ?? 'Breakfast';
    final dateStr = schedule['date'] ?? '';
    final notes = schedule['notes'] ?? '';

    Map<String, dynamic> mealData = {};
    try {
      final meal = schedule['meal'];
      if (meal is Map) {
        mealData = Map<String, dynamic>.from(meal);
      }
    } catch (e) {
      print('⚠️ Error converting meal data: $e');
    }

    final mealName = mealData['name'] ?? 'Unknown Meal';
    final mealCalories = mealData['calories']?.toString() ?? 'N/A';
    final mealCategory = mealData['category']?.toString() ?? 'Unknown';
    final imageUrl = mealData['image_url']?.toString();

    final formattedDate = schedule['created_at'] != null
        ? _formatDate(schedule['created_at'].toString())
        : _formatDateString(dateStr);

    Color getMealTimeColor(String mealTime) {
      switch (mealTime.toLowerCase()) {
        case 'breakfast':
          return const Color(0xFFFFB74D);
        case 'lunch':
          return const Color(0xFF4CAF50);
        case 'dinner':
          return const Color(0xFF2196F3);
        case 'snack':
          return const Color(0xFF9C27B0);
        default:
          return const Color(0xFF588D6E);
      }
    }

    IconData getMealTimeIcon(String mealTime) {
      switch (mealTime.toLowerCase()) {
        case 'breakfast':
          return Icons.breakfast_dining;
        case 'lunch':
          return Icons.lunch_dining;
        case 'dinner':
          return Icons.dinner_dining;
        case 'snack':
          return Icons.cookie;
        default:
          return Icons.restaurant;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: getMealTimeColor(mealTime).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: getMealTimeColor(mealTime),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        getMealTimeIcon(mealTime),
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mealTime,
                          style: TextStyle(
                            color: getMealTimeColor(mealTime),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'League Spartan',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _deleteSchedule(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: imageUrl != null && imageUrl.isNotEmpty
                            ? DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        )
                            : const DecorationImage(
                          image: NetworkImage(
                            'https://via.placeholder.com/60x60.png?text=No+Image',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mealName,
                            style: const TextStyle(
                              color: Color(0xFF391713),
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9F6FE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '$mealCalories Calories',
                                  style: const TextStyle(
                                    color: Color(0xFF588D6E),
                                    fontSize: 12,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE9F6FE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  mealCategory,
                                  style: const TextStyle(
                                    color: Color(0xFF588D6E),
                                    fontSize: 12,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (notes.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  const Text(
                    'Notes:',
                    style: TextStyle(
                      color: Color(0xFF588D6E),
                      fontSize: 14,
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    notes,
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 14,
                      fontFamily: 'League Spartan',
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatDateString(String dateString) {
    try {
      final parts = dateString.split('-');
      if (parts.length >= 3) {
        return '${parts[2]}/${parts[1]}/${parts[0]}';
      }
      return dateString;
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.home),
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
                        'Home',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
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
                            color: const Color(0xFFE2F163),
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
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Today's Schedule",
                      style: TextStyle(
                        color: Color(0xFF212020),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showForm = !_showForm;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF588D6E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _showForm ? Icons.visibility_off : Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _showForm ? 'Hide Add Form' : 'Show Add Form',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'My Eat Schedules',
                          style: TextStyle(
                            color: Color(0xFF588D6E),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Total: ${_existingSchedules.length} schedules',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontFamily: 'League Spartan',
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (_isLoadingSchedules)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF588D6E),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        else if (_existingSchedules.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color(0xFFE9F6FE),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  color: const Color(0xFF588D6E).withOpacity(0.5),
                                  size: 50,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'No schedules yet',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Create your first schedule below!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF888888),
                                    fontSize: 14,
                                    fontFamily: 'League Spartan',
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Column(
                            children: _existingSchedules
                                .asMap()
                                .entries
                                .map((entry) => _buildScheduleCard(entry.key, entry.value))
                                .toList(),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (_showForm)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create New Schedule',
                            style: TextStyle(
                              color: Color(0xFF588D6E),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 20),
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
                              GestureDetector(
                                onTap: () => _selectDate(context),
                                child: Container(
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
                                        child: Text(
                                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                          style: const TextStyle(
                                            color: Color(0xFF391713),
                                            fontSize: 16,
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(right: 15),
                                        child: Icon(
                                          Icons.arrow_drop_down,
                                          color: Color(0xFF588D6E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Meal Time',
                                style: TextStyle(
                                  color: Color(0xFF588D6E),
                                  fontSize: 18,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 70,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: mealTimes.length,
                                  itemBuilder: (context, index) {
                                    final mealTime = mealTimes[index];
                                    final isSelected = selectedMealTime == mealTime['name'];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedMealTime = mealTime['name'];
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 12),
                                        width: 80,
                                        decoration: BoxDecoration(
                                          color: isSelected ? mealTime['color'] : Colors.white,
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(
                                            color: isSelected ? mealTime['color'] : Color(0xFFE9F6FE),
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              mealTime['icon'],
                                              color: isSelected ? Colors.white : mealTime['color'],
                                              size: 24,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              mealTime['name'],
                                              style: TextStyle(
                                                color: isSelected ? Colors.white : Color(0xFF391713),
                                                fontSize: 12,
                                                fontFamily: 'League Spartan',
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Select Meal',
                                style: TextStyle(
                                  color: Color(0xFF588D6E),
                                  fontSize: 18,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 10),
                              isLoadingMeals
                                  ? Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF588D6E),
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                                  : errorMessage != null
                                  ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  errorMessage!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )
                                  : mealsList.isEmpty
                                  ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  'No meals available. Please add meals first.',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )
                                  : Container(
                                height: 350,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListView.builder(
                                  itemCount: mealsList.length,
                                  itemBuilder: (context, index) {
                                    final meal = mealsList[index];
                                    final isSelected = selectedMeal?['id'] == meal['id'];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF588D6E).withOpacity(0.05)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isSelected
                                              ? const Color(0xFF588D6E)
                                              : const Color(0xFFE9F6FE),
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                      child: ListTile(
                                        onTap: () {
                                          setState(() {
                                            selectedMeal = meal;
                                          });
                                        },
                                        leading: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: meal['image_url'] != null &&
                                                meal['image_url'].toString().isNotEmpty
                                                ? DecorationImage(
                                              image: NetworkImage(
                                                  meal['image_url'].toString()),
                                              fit: BoxFit.cover,
                                            )
                                                : const DecorationImage(
                                              image: NetworkImage(
                                                'https://via.placeholder.com/60x60.png?text=No+Image',
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              meal['name'] ?? 'Unknown Meal',
                                              style: const TextStyle(
                                                color: Color(0xFF391713),
                                                fontSize: 16,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            if (meal['category']?.isNotEmpty == true)
                                              Container(
                                                margin: const EdgeInsets.only(top: 4),
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: const Color(0xFF588D6E)
                                                      .withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                                child: Text(
                                                  meal['category'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF588D6E),
                                                    fontSize: 12,
                                                    fontFamily: 'League Spartan',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (meal['description']?.isNotEmpty == true)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4),
                                                child: Text(
                                                  meal['description'],
                                                  style: const TextStyle(
                                                    color: Color(0xFF666666),
                                                    fontSize: 14,
                                                    fontFamily: 'League Spartan',
                                                  ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.local_fire_department,
                                                  color: Colors.orange,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  '${meal['calories']} Calories',
                                                  style: const TextStyle(
                                                    color: Color(0xFF666666),
                                                    fontSize: 14,
                                                    fontFamily: 'League Spartan',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        trailing: Container(
                                          width: 24,
                                          height: 24,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xFF588D6E)
                                                  : Colors.grey,
                                              width: 2,
                                            ),
                                            color: isSelected
                                                ? const Color(0xFF588D6E)
                                                : Colors.transparent,
                                          ),
                                          child: isSelected
                                              ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 16,
                                          )
                                              : null,
                                        ),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          if (selectedMeal != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Selected Meal',
                                    style: TextStyle(
                                      color: Color(0xFF588D6E),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          image: selectedMeal!['image_url'] != null &&
                                              selectedMeal!['image_url'].toString().isNotEmpty
                                              ? DecorationImage(
                                            image: NetworkImage(
                                                selectedMeal!['image_url'].toString()),
                                            fit: BoxFit.cover,
                                          )
                                              : const DecorationImage(
                                            image: NetworkImage(
                                              'https://via.placeholder.com/80x80.png?text=No+Image',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    selectedMeal!['name'] ?? 'Unknown Meal',
                                                    style: const TextStyle(
                                                      color: Color(0xFF391713),
                                                      fontSize: 18,
                                                      fontFamily: 'Poppins',
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (selectedMeal!['category']?.isNotEmpty == true)
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: const Color(0xFF588D6E),
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                    child: Text(
                                                      selectedMeal!['category'],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: 'League Spartan',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.local_fire_department,
                                                  color: Colors.orange,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  '${selectedMeal!['calories']} Calories',
                                                  style: const TextStyle(
                                                    color: Color(0xFF666666),
                                                    fontSize: 14,
                                                    fontFamily: 'League Spartan',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (selectedMeal!['description']?.isNotEmpty == true)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      'Description:',
                                                      style: TextStyle(
                                                        color: Color(0xFF588D6E),
                                                        fontSize: 14,
                                                        fontFamily: 'League Spartan',
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    Text(
                                                      selectedMeal!['description'],
                                                      style: const TextStyle(
                                                        color: Color(0xFF666666),
                                                        fontSize: 14,
                                                        fontFamily: 'League Spartan',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Notes',
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
                                height: 100,
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  child: _notesController != null
                                      ? TextField(
                                    controller: _notesController,
                                    maxLines: 4,
                                    style: const TextStyle(
                                      color: Color(0xFF391713),
                                      fontSize: 16,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w400,
                                    ),
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Add any additional notes...',
                                      hintStyle: TextStyle(
                                        color: Color(0x4C391713),
                                        fontSize: 16,
                                        fontFamily: 'League Spartan',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  )
                                      : const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF588D6E),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: GestureDetector(
                              onTap: _saveSchedule,
                              child: Container(
                                width: 200,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF588D6E),
                                  borderRadius: BorderRadius.circular(25),
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
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
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
}