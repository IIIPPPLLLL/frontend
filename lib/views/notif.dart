import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../routes/app_routes.dart';
import '../service/api_service.dart';

class Notification1 extends StatefulWidget {
  const Notification1({super.key});

  @override
  State<Notification1> createState() => _Notification1State();
}

class _Notification1State extends State<Notification1> {
  bool isLoading = true;
  List<Map<String, dynamic>> notifications = [];

  // ================= TOKEN =================
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // ================= FETCH =================
  Future<void> _loadNotifications({bool showLoading = true}) async {
    if (showLoading) setState(() => isLoading = true);

    try {
      final token = await _getToken();
      if (token == null) return;

      final res = await ApiService.getNotifications(token);

      if (res is List) {
        final data = res
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        data.sort((a, b) => _getDate(b).compareTo(_getDate(a)));
        setState(() => notifications = data);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ================= HELPERS =================
  String getNotificationId(Map<String, dynamic> n) {
    return n['_id']['\$oid'];
  }

  DateTime _getDate(Map<String, dynamic> n) {
    try {
      final ms =
      int.parse(n['created_at']['\$date']['\$numberLong']);
      return DateTime.fromMillisecondsSinceEpoch(ms);
    } catch (_) {
      return DateTime.now();
    }
  }

  bool _isUnread(Map<String, dynamic> n) =>
      n['is_read'] != true;

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes}m lalu';
    if (diff.inDays < 1) return '${diff.inHours}j lalu';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final unread = notifications.where(_isUnread).toList();
    final read =
    notifications.where((n) => !_isUnread(n)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Stack(
          children: [
            // ================= CONTENT =================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      color: Color(0xFF588D6E),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Expanded(
                    child: isLoading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : RefreshIndicator(
                      onRefresh: () =>
                          _loadNotifications(showLoading: false),
                      child: ListView(
                        children: [
                          if (unread.isNotEmpty) ...[
                            _sectionTitle('Belum Dibaca'),
                            ...unread.map(_item),
                            const SizedBox(height: 24),
                          ],
                          if (read.isNotEmpty) ...[
                            _sectionTitle('Sudah Dibaca'),
                            ...read.map(_item),
                          ],
                          if (unread.isEmpty && read.isEmpty)
                            const Center(
                              child: Text(
                                'Belum ada notifikasi',
                                style: TextStyle(
                                    color: Colors.white54),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ================= NAVBAR (PERSIS PUNYA KAMU) =================
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 59,
                color: const Color(0xFF588D6E),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navIcon(
                      'assets/icons/logo-home2.svg',
                          () => Navigator.pushNamed(
                          context, AppRoutes.home),
                    ),
                    _navIcon(
                      'assets/icons/icon-doc.svg',
                          () => Navigator.pushNamed(
                          context, AppRoutes.tracking),
                    ),
                    _navIcon(
                      'assets/icons/logo-star.svg',
                          () => Navigator.pushNamed(
                          context, AppRoutes.home),
                    ),
                    _navIcon(
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

  // ================= COMPONENT =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF588D6E),
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _item(Map<String, dynamic> n) {
    final unread = _isUnread(n);

    return GestureDetector(
      onTap: () async {
        final token = await _getToken();
        final id = getNotificationId(n);

        if (unread && token != null) {
          await ApiService.readNotification(token, id);
          await _loadNotifications(showLoading: false);
        }

        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(n['title']),
            content: Text(n['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              )
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: unread
              ? Border.all(color: const Color(0xFF588D6E))
              : null,
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF588D6E),
              child:
              Icon(Icons.notifications, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    n['title'],
                    style: TextStyle(
                      color: Colors.black, // ✅ TEKS HITAM
                      fontWeight: unread
                          ? FontWeight.bold
                          : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    n['message'],
                    style:
                    const TextStyle(color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _timeAgo(_getDate(n)),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
            if (unread)
              const Icon(Icons.circle,
                  size: 10, color: Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: 24,
        height: 24,
        color: Colors.white,
      ),
    );
  }
}
