import 'package:flutter/material.dart';
import '../routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../service/api_service.dart';

class EatSchedule2 extends StatefulWidget {
  const EatSchedule2({super.key});

  @override
  State<EatSchedule2> createState() => _EatSchedule2State();
}

class _EatSchedule2State extends State<EatSchedule2> {
  // Kontroller untuk TextField
  final _listNameController = TextEditingController(text: "My Shopping List");
  final _descriptionController = TextEditingController(text: "Items to buy");

  // List untuk menyimpan items - AWALNYA KOSONG
  final List<Map<String, dynamic>> _items = [];

  // List untuk menyimpan shopping list yang sudah ada
  List<Map<String, dynamic>> _existingShoppingLists = [];
  bool _isLoadingLists = true;
  bool _showForm = true; // State untuk menampilkan/sembunyikan form

  // Dropdown options
  final List<String> _unitOptions = ['grams', 'kg', 'pieces', 'liters', 'bulbs', 'ml', 'pack', 'bottle'];
  final List<String> _categoryOptions = ['Protein', 'Carbs', 'Vegetables', 'Dairy', 'Fats', 'Seasonings', 'Fruits', 'Snacks', 'Beverages', 'Others'];

  // Konstanta untuk max items
  static const int _maxItems = 10;

  @override
  void initState() {
    super.initState();
    _loadExistingShoppingLists();
  }

  @override
  void dispose() {
    // Dispose semua controller
    _listNameController.dispose();
    _descriptionController.dispose();
    for (var item in _items) {
      item['nameController']?.dispose();
      item['quantityController']?.dispose();
      item['unitController']?.dispose();
      item['categoryController']?.dispose();
      item['notesController']?.dispose();
    }
    super.dispose();
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

  Future<void> _loadExistingShoppingLists() async {
    print('🔄 === LOADING EXISTING SHOPPING LISTS ===');

    try {
      setState(() {
        _isLoadingLists = true;
      });

      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print('❌ Token is null');
        setState(() {
          _isLoadingLists = false;
        });
        return;
      }

      // Call API to get existing shopping lists
      final response = await ApiService.getShoppingList(token);

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          print('✅ Shopping lists data received');
          print('📊 Full response data: $data');

          List<dynamic> listsData = [];

          // Parse data sesuai struktur API yang diberikan
          if (data.containsKey('data') && data['data'] is List) {
            listsData = data['data'] as List<dynamic>;
            print('🔍 Found data in key: data, count: ${listsData.length}');
          } else {
            print('❌ No list data found in response. Available keys: ${data.keys}');
            setState(() {
              _isLoadingLists = false;
            });
            return;
          }

          print('📦 Total lists found: ${listsData.length}');

          // Debug: print each list structure
          for (int i = 0; i < listsData.length; i++) {
            print('--- List $i ---');
            print('Full list data: ${listsData[i]}');
            if (listsData[i] is Map) {
              final listMap = listsData[i] as Map;
              print('Keys in list: ${listMap.keys}');

              // Periksa struktur shopping_list dari data contoh
              if (listMap['shopping_list'] != null) {
                print('✅ shopping_list key found, type: ${listMap['shopping_list'].runtimeType}');
                if (listMap['shopping_list'] is List) {
                  print('✅ shopping_list is a List, length: ${(listMap['shopping_list'] as List).length}');
                  print('✅ First item in shopping_list: ${(listMap['shopping_list'] as List).isNotEmpty ? (listMap['shopping_list'] as List)[0] : "Empty"}');
                }
              } else {
                print('❌ No shopping_list key in this list');
              }
            }
          }

          setState(() {
            _existingShoppingLists = listsData.map<Map<String, dynamic>>((list) {
              print('📝 Processing list: $list');

              // SESUAIKAN DENGAN STRUKTUR DATA API
              // Dari contoh data: shopping_list adalah key yang berisi array items
              List<dynamic> itemsData = [];
              if (list is Map && list['shopping_list'] is List) {
                itemsData = list['shopping_list'] as List<dynamic>;
                print('✅ Found items in key: shopping_list, count: ${itemsData.length}');
              }
              // Fallback ke key lainnya jika shopping_list tidak ada
              else if (list is Map && list['items'] is List) {
                itemsData = list['items'] as List<dynamic>;
                print('✅ Found items in key: items, count: ${itemsData.length}');
              } else if (list is Map) {
                print('❌ No items found in list. Available keys: ${list.keys}');
              }

              // Debug item structure
              if (itemsData.isNotEmpty && itemsData[0] is Map) {
                print('🛒 Item structure example:');
                final exampleItem = itemsData[0] as Map;
                print('  - id: ${exampleItem['id']}');
                print('  - name: ${exampleItem['name']}');
                print('  - quantity: ${exampleItem['quantity']}');
                print('  - unit: ${exampleItem['unit']}');
                print('  - category: ${exampleItem['category']}');
                print('  - purchased: ${exampleItem['purchased']}');
                print('  - notes: ${exampleItem['notes']}');
              }

              return {
                'id': list is Map ? (list['id']?.toString() ?? '') : '',
                'name': list is Map ? (list['name']?.toString() ?? 'Untitled List') : 'Untitled List',
                'description': list is Map ? (list['description']?.toString() ?? '') : '',
                'created_at': list is Map ? (list['created_at']?.toString() ?? '') : '',
                'updated_at': list is Map ? (list['updated_at']?.toString() ?? '') : '',
                'items': itemsData.map<Map<String, dynamic>>((item) {
                  print('📋 Processing item: $item');
                  // SESUAIKAN DENGAN STRUKTUR ITEM DARI API
                  // Dari contoh data: id, name, quantity, unit, category, purchased, notes
                  return {
                    'id': item is Map ? (item['id']?.toString() ?? '') : '',
                    'name': item is Map ? (item['name']?.toString() ?? 'Unnamed Item') : 'Unnamed Item',
                    'quantity': item is Map ? (item['quantity']?.toString() ?? '1') : '1',
                    'unit': item is Map ? (item['unit']?.toString() ?? 'pieces') : 'pieces',
                    'category': item is Map ? (item['category']?.toString() ?? '') : '',
                    'notes': item is Map ? (item['notes']?.toString() ?? '') : '',
                    // Gunakan 'purchased' dari API sebagai 'is_completed'
                    'is_completed': item is Map ? (item['purchased'] ?? false) : false,
                  };
                }).toList(),
              };
            }).toList();

            _isLoadingLists = false;
          });

          print('✅ ${_existingShoppingLists.length} shopping lists loaded');

          // Debug: print first list details
          if (_existingShoppingLists.isNotEmpty) {
            print('📋 First list details:');
            print('  - Name: ${_existingShoppingLists[0]['name']}');
            print('  - Description: ${_existingShoppingLists[0]['description']}');
            print('  - Items count: ${_existingShoppingLists[0]['items'].length}');
            if (_existingShoppingLists[0]['items'].isNotEmpty) {
              print('  - First item: ${_existingShoppingLists[0]['items'][0]}');
            } else {
              print('  - No items in the first list');
            }
          }
        } catch (e) {
          print('❌ JSON Parse Error: $e');
          print('📄 Response body: ${response.body}');
          setState(() {
            _isLoadingLists = false;
          });
        }
      } else {
        print('❌ Failed to load shopping lists: ${response.statusCode}');
        print('📄 Response body: ${response.body}');
        setState(() {
          _isLoadingLists = false;
        });
      }
    } catch (e) {
      print('❌ Exception loading shopping lists: $e');
      setState(() {
        _isLoadingLists = false;
      });
    }
  }

  Future<void> _deleteShoppingList(int index) async {
    print('🗑️ === DELETING SHOPPING LIST ===');

    try {
      // Debug: Tampilkan semua data dari list yang akan dihapus
      print('📋 Full list data at index $index: ${_existingShoppingLists[index]}');

      // Ambil ID dengan beberapa cara untuk memastikan
      final dynamic idData = _existingShoppingLists[index]['id'];
      print('🔍 Raw ID data: $idData');
      print('🔍 Raw ID type: ${idData.runtimeType}');

      // Convert ID ke string dengan aman
      String listId;
      if (idData == null) {
        print('❌ ID is null!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot delete: List ID is null'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      } else if (idData is int) {
        listId = idData.toString();
      } else if (idData is String) {
        listId = idData.trim();
      } else {
        listId = idData.toString().trim();
      }

      print('✅ List ID setelah konversi: "$listId"');
      print('✅ List ID length: ${listId.length}');

      if (listId.isEmpty) {
        print('❌ List ID is empty string');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot delete: List ID is empty'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Show confirmation dialog
      bool confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Delete Shopping List',
            style: TextStyle(
              color: Color(0xFF391713),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to delete "${_existingShoppingLists[index]['name']}"?',
            style: const TextStyle(
              color: Color(0xFF666666),
              fontFamily: 'League Spartan',
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF588D6E),
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'League Spartan',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ) ?? false;

      if (!confirmDelete) {
        return;
      }

      final token = await _getToken();

      if (token == null || token.isEmpty) {
        print('❌ Token is null or empty');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session expired. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      print('🔑 Token length: ${token.length}');

      // Call API to delete shopping list
      final response = await ApiService.deleteShoppingList(token, listId);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Shopping list deleted successfully');

        // Remove from local list
        setState(() {
          _existingShoppingLists.removeAt(index);
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shopping list deleted successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('❌ Failed to delete shopping list: ${response.statusCode}');
        print('📡 Full response: ${response.toString()}');

        // Try to parse error message
        String errorMessage = 'Unknown error';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ??
              errorData['error'] ??
              errorData['detail'] ??
              response.body;
        } catch (e) {
          errorMessage = response.body;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Exception deleting shopping list: $e');
      print('🔥 Stack trace: ${e.toString()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveShoppingList() async {
    print('💾 === SAVING SHOPPING LIST ===');

    // Validasi: minimal 1 item harus memiliki nama
    bool hasValidItems = false;
    for (var item in _items) {
      final name = item['nameController']?.text?.trim() ?? '';
      if (name.isNotEmpty) {
        hasValidItems = true;
        break;
      }
    }

    if (!hasValidItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one item with a name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validasi: list name tidak boleh kosong
    if (_listNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a list name'),
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

      // Filter hanya item yang memiliki nama
      final validItems = _items.where((item) {
        final name = item['nameController']?.text?.trim() ?? '';
        return name.isNotEmpty;
      }).toList();

      if (validItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one item with a name'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Prepare shopping list data
      final shoppingListData = {
        'name': _listNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'items': validItems.map((item) {
          return {
            'name': item['nameController']?.text?.trim() ?? '',
            'quantity': int.tryParse(item['quantityController']?.text ?? '1') ?? 1,
            'unit': item['unitController']?.text ?? 'pieces',
            'category': item['categoryController']?.text ?? 'Others',
            'notes': item['notesController']?.text?.trim().isEmpty == true ? null : item['notesController']?.text?.trim(),
          };
        }).toList(),
      };

      print('📤 Sending shopping list data: $shoppingListData');

      // Call API to save shopping list
      final response = await ApiService.shoppingList(token, shoppingListData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Shopping list saved successfully');

        // Clear form setelah berhasil save
        _clearForm();

        // Refresh existing lists
        _loadExistingShoppingLists();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Shopping list saved successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        print('❌ Failed to save shopping list: ${response.statusCode}');
        print('📡 Response Body: ${response.body}');

        try {
          final errorData = jsonDecode(response.body);
          final errorMsg = errorData['message'] ?? errorData['error'] ?? 'Unknown error';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save: $errorMsg'),
              backgroundColor: Colors.red,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save shopping list: ${response.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Exception saving shopping list: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _clearForm() {
    setState(() {
      _listNameController.text = "My Shopping List";
      _descriptionController.text = "Items to buy";

      // Clear semua items
      for (var item in _items) {
        item['nameController']?.dispose();
        item['quantityController']?.dispose();
        item['unitController']?.dispose();
        item['categoryController']?.dispose();
        item['notesController']?.dispose();
      }
      _items.clear();
    });
  }

  void _addNewItem() {
    if (_items.length >= _maxItems) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maximum $_maxItems items reached'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _items.add({
        'name': '',
        'quantity': 1,
        'unit': 'pieces',
        'category': 'Others',
        'notes': '',
        'nameController': TextEditingController(),
        'quantityController': TextEditingController(text: '1'),
        'unitController': TextEditingController(text: 'pieces'),
        'categoryController': TextEditingController(text: 'Others'),
        'notesController': TextEditingController(),
        'expanded': true, // Item baru otomatis expanded
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      // Dispose controllers sebelum menghapus item
      _items[index]['nameController']?.dispose();
      _items[index]['quantityController']?.dispose();
      _items[index]['unitController']?.dispose();
      _items[index]['categoryController']?.dispose();
      _items[index]['notesController']?.dispose();
      _items.removeAt(index);
    });
  }

  void _toggleExpandItem(int index) {
    setState(() {
      _items[index]['expanded'] = !_items[index]['expanded'];
    });
  }

  // Metode untuk menampilkan bottom sheet pilihan unit
  void _showUnitBottomSheet(BuildContext context, int itemIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Select Unit',
                  style: TextStyle(
                    color: Color(0xFF391713),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) {
                    // Filter options saat mengetik
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search unit...',
                    hintStyle: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                    ),
                    icon: Icon(Icons.search, color: Color(0xFF588D6E), size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _unitOptions.length,
                  itemBuilder: (context, index) {
                    final unit = _unitOptions[index];
                    final isSelected = unit == _items[itemIndex]['unitController']?.text;

                    // Ikon berdasarkan jenis unit
                    IconData unitIcon = Icons.category;
                    if (unit.contains('gram') || unit.contains('kg')) {
                      unitIcon = Icons.scale;
                    } else if (unit.contains('liter') || unit.contains('ml')) {
                      unitIcon = Icons.water_drop;
                    } else if (unit.contains('piece')) {
                      unitIcon = Icons.layers;
                    } else if (unit.contains('bulb')) {
                      unitIcon = Icons.lightbulb;
                    } else if (unit.contains('pack') || unit.contains('bottle')) {
                      unitIcon = Icons.inventory;
                    }

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF588D6E).withOpacity(0.1) : const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          unitIcon,
                          color: isSelected ? const Color(0xFF588D6E) : const Color(0xFF666666),
                          size: 20,
                        ),
                      ),
                      title: Text(
                        unit,
                        style: TextStyle(
                          color: const Color(0xFF391713),
                          fontSize: 16,
                          fontFamily: 'League Spartan',
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                        Icons.check_circle,
                        color: Color(0xFF588D6E),
                        size: 24,
                      )
                          : null,
                      onTap: () {
                        setState(() {
                          _items[itemIndex]['unitController']?.text = unit;
                        });
                        Navigator.pop(context);
                      },
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Metode untuk menampilkan bottom sheet pilihan category
  void _showCategoryBottomSheet(BuildContext context, int itemIndex) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Select Category',
                  style: TextStyle(
                    color: Color(0xFF391713),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  onChanged: (value) {
                    // Filter options saat mengetik
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search category...',
                    hintStyle: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 14,
                    ),
                    icon: Icon(Icons.search, color: Color(0xFF588D6E), size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _categoryOptions.length,
                  itemBuilder: (context, index) {
                    final category = _categoryOptions[index];
                    final isSelected = category == _items[itemIndex]['categoryController']?.text;

                    // Ikon berdasarkan kategori
                    IconData categoryIcon = Icons.category;
                    Color categoryColor = const Color(0xFF588D6E);

                    if (category == 'Protein') {
                      categoryIcon = Icons.egg;
                      categoryColor = const Color(0xFFFF9800);
                    } else if (category == 'Vegetables') {
                      categoryIcon = Icons.eco;
                      categoryColor = const Color(0xFF4CAF50);
                    } else if (category == 'Fruits') {
                      categoryIcon = Icons.apple;
                      categoryColor = const Color(0xFFF44336);
                    } else if (category == 'Dairy') {
                      categoryIcon = Icons.agriculture;
                      categoryColor = const Color(0xFF2196F3);
                    } else if (category == 'Carbs') {
                      categoryIcon = Icons.bakery_dining;
                      categoryColor = const Color(0xFF795548);
                    } else if (category == 'Beverages') {
                      categoryIcon = Icons.local_drink;
                      categoryColor = const Color(0xFF00BCD4);
                    } else if (category == 'Snacks') {
                      categoryIcon = Icons.cookie;
                      categoryColor = const Color(0xFFFFC107);
                    }

                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: categoryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: categoryColor,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        category,
                        style: TextStyle(
                          color: const Color(0xFF391713),
                          fontSize: 16,
                          fontFamily: 'League Spartan',
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(
                        Icons.check_circle,
                        color: categoryColor,
                        size: 24,
                      )
                          : null,
                      onTap: () {
                        setState(() {
                          _items[itemIndex]['categoryController']?.text = category;
                        });
                        Navigator.pop(context);
                      },
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Widget untuk menampilkan item shopping list yang bisa diperkecil
  Widget _buildShoppingItem(int index, Map<String, dynamic> item) {
    final isExpanded = item['expanded'] ?? false;
    final itemName = item['nameController']?.text?.trim() ?? '';
    final displayName = itemName.isEmpty ? 'New Item' : itemName;
    final quantity = item['quantityController']?.text ?? '1';
    final unit = item['unitController']?.text ?? 'pieces';
    final category = item['categoryController']?.text ?? 'Others';

    // Warna kategori
    Color getCategoryColor(String category) {
      switch (category) {
        case 'Protein':
          return const Color(0xFFFF9800);
        case 'Vegetables':
          return const Color(0xFF4CAF50);
        case 'Fruits':
          return const Color(0xFFF44336);
        case 'Dairy':
          return const Color(0xFF2196F3);
        case 'Carbs':
          return const Color(0xFF795548);
        case 'Beverages':
          return const Color(0xFF00BCD4);
        case 'Snacks':
          return const Color(0xFFFFC107);
        default:
          return const Color(0xFF588D6E);
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
          // Item header dengan toggle expand dan delete
          GestureDetector(
            onTap: () => _toggleExpandItem(index),
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isExpanded ? const Color(0xFF588D6E).withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15),
                  bottomLeft: isExpanded ? Radius.zero : const Radius.circular(15),
                  bottomRight: isExpanded ? Radius.zero : const Radius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF588D6E),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                style: const TextStyle(
                                  color: Color(0xFF391713),
                                  fontSize: 16,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (!isExpanded)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE9F6FE),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          '$quantity $unit',
                                          style: const TextStyle(
                                            color: Color(0xFF588D6E),
                                            fontSize: 12,
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: getCategoryColor(category).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          category,
                                          style: TextStyle(
                                            color: getCategoryColor(category),
                                            fontSize: 12,
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w500,
                                          ),
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
                  ),
                  Row(
                    children: [
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        color: const Color(0xFF588D6E),
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _removeItem(index),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            shape: BoxShape.circle,
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
                ],
              ),
            ),
          ),

          // Content area (hanya tampil jika expanded)
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Name
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Item Name *',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE9F6FE),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: item['nameController'],
                          style: const TextStyle(
                            color: Color(0xFF391713),
                            fontSize: 14,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                            hintText: 'e.g., Chicken Breast',
                            hintStyle: TextStyle(
                              color: Color(0x4C391713),
                              fontSize: 14,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Quantity and Unit in one row
                  Row(
                    children: [
                      // Quantity
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Quantity',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xFFE9F6FE),
                                  width: 1,
                                ),
                              ),
                              child: TextField(
                                controller: item['quantityController'],
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Color(0xFF391713),
                                  fontSize: 14,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 12),
                                  hintText: 'e.g., 1',
                                  hintStyle: TextStyle(
                                    color: Color(0x4C391713),
                                    fontSize: 14,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),

                      // Unit (Improved Dropdown)
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Unit',
                              style: TextStyle(
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontFamily: 'League Spartan',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            GestureDetector(
                              onTap: () => _showUnitBottomSheet(context, index),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFE9F6FE),
                                    width: 1,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item['unitController']?.text ?? 'pieces',
                                      style: const TextStyle(
                                        color: Color(0xFF391713),
                                        fontSize: 14,
                                        fontFamily: 'League Spartan',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_drop_down,
                                      color: Color(0xFF588D6E),
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Category (Improved Dropdown)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Category',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () => _showCategoryBottomSheet(context, index),
                        child: Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFFE9F6FE),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  // Ikon kategori
                                  Icon(
                                    _getCategoryIcon(item['categoryController']?.text ?? 'Others'),
                                    color: getCategoryColor(item['categoryController']?.text ?? 'Others'),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    item['categoryController']?.text?.isNotEmpty == true
                                        ? item['categoryController']?.text ?? 'Others'
                                        : 'Others',
                                    style: const TextStyle(
                                      color: Color(0xFF391713),
                                      fontSize: 14,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(
                                Icons.arrow_drop_down,
                                color: Color(0xFF588D6E),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Notes
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notes (Optional)',
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontFamily: 'League Spartan',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFFE9F6FE),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: item['notesController'],
                          maxLines: 2,
                          style: const TextStyle(
                            color: Color(0xFF391713),
                            fontSize: 14,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            hintText: 'e.g., Fresh, not frozen',
                            hintStyle: TextStyle(
                              color: Color(0x4C391713),
                              fontSize: 14,
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Helper function untuk mendapatkan ikon kategori
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Protein':
        return Icons.egg;
      case 'Vegetables':
        return Icons.eco;
      case 'Fruits':
        return Icons.apple;
      case 'Dairy':
        return Icons.agriculture;
      case 'Carbs':
        return Icons.bakery_dining;
      case 'Beverages':
        return Icons.local_drink;
      case 'Snacks':
        return Icons.cookie;
      case 'Seasonings':
        return Icons.emoji_food_beverage;
      case 'Fats':
        return Icons.water_drop;
      default:
        return Icons.category;
    }
  }

  // Widget untuk menampilkan shopping list yang sudah ada
  Widget _buildShoppingListCard(int index, Map<String, dynamic> shoppingList) {
    final items = shoppingList['items'] as List<dynamic>;
    final itemCount = items.length;
    final name = shoppingList['name'] ?? 'Untitled List';
    final description = shoppingList['description']?.isNotEmpty == true
        ? shoppingList['description']
        : 'No description provided';
    final formattedDate = shoppingList['created_at'] != null
        ? _formatDate(shoppingList['created_at'].toString())
        : 'No date';

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
          // Header dengan nama dan deskripsi
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: const Color(0xFF588D6E).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              color: Color(0xFF391713),
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF588D6E).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '$itemCount item${itemCount != 1 ? 's' : ''}',
                                  style: const TextStyle(
                                    color: Color(0xFF588D6E),
                                    fontSize: 12,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (shoppingList['id'] != null && shoppingList['id'].isNotEmpty)
                                GestureDetector(
                                  onTap: () => _deleteShoppingList(index),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                          size: 12,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 12,
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
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
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    fontFamily: 'League Spartan',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'Created: $formattedDate',
                  style: const TextStyle(
                    color: Color(0xFF888888),
                    fontSize: 12,
                    fontFamily: 'League Spartan',
                  ),
                ),
              ],
            ),
          ),

          // Items list - TAMPILKAN MESKIPUN KOSONG
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Items:',
                  style: TextStyle(
                    color: Color(0xFF588D6E),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),

                if (items.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFE9F6FE),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.info,
                          color: Colors.orange,
                          size: 16,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'No items saved in this list',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 14,
                            fontFamily: 'League Spartan',
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...items.map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFE9F6FE),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 6, right: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF588D6E),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['name'] ?? 'Unnamed Item',
                                        style: const TextStyle(
                                          color: Color(0xFF391713),
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w500,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (item['is_completed'] == true)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Text(
                                          'Completed',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE9F6FE),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${item['quantity']} ${item['unit']}',
                                        style: const TextStyle(
                                          color: Color(0xFF588D6E),
                                          fontSize: 12,
                                          fontFamily: 'League Spartan',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (item['category']?.isNotEmpty == true)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFE9F6FE),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          item['category'],
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
                                if (item['notes']?.isNotEmpty == true)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Notes:',
                                          style: TextStyle(
                                            color: Color(0xFF666666),
                                            fontSize: 12,
                                            fontFamily: 'League Spartan',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          item['notes'],
                                          style: const TextStyle(
                                            color: Color(0xFF888888),
                                            fontSize: 12,
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
                    ),
                  )).toList(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF232222),
      body: SafeArea(
        child: Column(
          children: [
            // Header dengan SingleChildScrollView
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button dan title
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, AppRoutes.eat1),
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
                        'Shopping Lists',
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
                          // Already on this page
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

                  // Toggle button untuk show/hide form
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

            // Konten utama dengan Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bagian 1: Tampilkan Existing Shopping Lists
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          'My Shopping Lists',
                          style: TextStyle(
                            color: Color(0xFF588D6E),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Total: ${_existingShoppingLists.length} lists',
                          style: const TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontFamily: 'League Spartan',
                          ),
                        ),
                        const SizedBox(height: 20),

                        if (_isLoadingLists)
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
                        else if (_existingShoppingLists.isEmpty)
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
                                  Icons.shopping_cart_outlined,
                                  color: const Color(0xFF588D6E).withOpacity(0.5),
                                  size: 50,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'No shopping lists yet',
                                  style: TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Create your first shopping list below!',
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
                            children: _existingShoppingLists
                                .asMap()
                                .entries
                                .map((entry) => _buildShoppingListCard(entry.key, entry.value))
                                .toList(),
                          ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Bagian 2: Form untuk Add New Shopping List (Tampil/Sembunyi)
                    if (_showForm)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Create New Shopping List',
                            style: TextStyle(
                              color: Color(0xFF588D6E),
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // List Name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'List Name *',
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
                                  controller: _listNameController,
                                  style: const TextStyle(
                                    color: Color(0xFF391713),
                                    fontSize: 16,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15),
                                    hintText: 'Enter list name',
                                    hintStyle: TextStyle(
                                      color: Color(0x4C391713),
                                      fontSize: 16,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Description
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description',
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
                                height: 80,
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
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  style: const TextStyle(
                                    color: Color(0xFF391713),
                                    fontSize: 16,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w400,
                                  ),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                    hintText: 'Enter description',
                                    hintStyle: TextStyle(
                                      color: Color(0x4C391713),
                                      fontSize: 16,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // Items Header with counter
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Shopping Items',
                                    style: TextStyle(
                                      color: Color(0xFF588D6E),
                                      fontSize: 18,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${_items.length}/$_maxItems items',
                                    style: TextStyle(
                                      color: _items.length >= _maxItems ? Colors.orange : const Color(0xFF666666),
                                      fontSize: 12,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: _items.length >= _maxItems ? null : _addNewItem,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: _items.length >= _maxItems ? Colors.grey : const Color(0xFF588D6E),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Add Item',
                                        style: TextStyle(
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
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Items List - jika kosong, tampilkan pesan
                          if (_items.isEmpty)
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              padding: const EdgeInsets.all(20),
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
                                    Icons.shopping_cart_outlined,
                                    color: const Color(0xFF588D6E).withOpacity(0.5),
                                    size: 50,
                                  ),
                                  const SizedBox(height: 10),
                                  const Text(
                                    'No items yet',
                                    style: TextStyle(
                                      color: Color(0xFF666666),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  const Text(
                                    'Tap "Add Item" to start creating your shopping list',
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
                          // Tampilkan semua item
                            ..._items.asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              return _buildShoppingItem(index, item);
                            }).toList(),

                          // Peringatan jika mencapai max items
                          if (_items.length >= _maxItems)
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.orange.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Maximum $_maxItems items reached. Remove an item to add new ones.',
                                      style: TextStyle(
                                        color: Colors.orange[800],
                                        fontSize: 13,
                                        fontFamily: 'League Spartan',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 40),

                          // Save Schedule Button
                          Center(
                            child: GestureDetector(
                              onTap: _saveShoppingList,
                              child: Container(
                                width: 178.56,
                                height: 44,
                                decoration: ShapeDecoration(
                                  color: const Color(0xFF588D6E),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Save Shopping List',
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
                          ),

                          const SizedBox(height: 20),

                          // Clear Form Button
                          Center(
                            child: GestureDetector(
                              onTap: _clearForm,
                              child: Container(
                                width: 150,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Clear Form',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 14,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w500,
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