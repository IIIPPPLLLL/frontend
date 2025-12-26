import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../routes/app_routes.dart';
import '../service/api_service.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> messages = [];
  bool isTyping = false;
  bool isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  // ================= LOAD HISTORY =================
  Future<void> _loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await ApiService.getHistoryChatBot(token);
      final decoded = jsonDecode(response.body);
      final List history = decoded['data']['messages'];

      setState(() {
        messages = history.map<Map<String, dynamic>>((item) {
          return {
            "from": item['role'] == 'assistant' ? 'bot' : 'user',
            "text": item['content'],
          };
        }).toList();

        if (messages.isEmpty) {
          messages.add({
            "from": "bot",
            "text": "Hi 👋 Aku asisten nutrisi kamu. Ada yang bisa aku bantu?",
          });
        }

        isLoadingHistory = false;
      });

      _scrollToBottom();
    } catch (_) {
      setState(() {
        isLoadingHistory = false;
        messages = [
          {
            "from": "bot",
            "text": "Hi 👋 Aku asisten nutrisi kamu. Ada yang bisa aku bantu?",
          }
        ];
      });
    }
  }

  // ================= SEND MESSAGE =================
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({"from": "user", "text": text});
      isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null) throw Exception('Token tidak tersedia');

      final response = await ApiService.askChatBot(token, text);

      setState(() {
        isTyping = false;
        messages.add({
          "from": "bot",
          "text": response.reply,
        });
      });

      for (final action in response.actions) {
        _handleAction(action);
      }
    } catch (_) {
      setState(() {
        isTyping = false;
        messages.add({
          "from": "bot",
          "text": "❌ Terjadi kesalahan. Coba lagi ya.",
        });
      });
    }

    _scrollToBottom();
  }

  // ================= HANDLE ACTION =================
  Future<void> _handleAction(Map<String, dynamic> action) async {
    final type = action['action_type'];
    final data = action['data'] ?? {};

    if (type == 'recommend_meal' && data.isNotEmpty) {
      final chatBuffer = StringBuffer('🍽️ Rekomendasi Makan:\n');
      final notifBuffer = StringBuffer();

      data.forEach((key, value) {
        final label = key.toString().replaceAll('_', ' ').toUpperCase();
        chatBuffer.writeln('• $label: $value');
        notifBuffer.writeln('$label: $value');
      });

      setState(() {
        messages.add({
          "from": "bot",
          "text": chatBuffer.toString(),
        });
      });

      _scrollToBottom();

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token == null) return;

        await ApiService.createNotification(
          token: token,
          title: '🍽️ Rekomendasi Makan Hari Ini',
          message: notifBuffer.toString(),
          icon: 'food',
        );
      } catch (_) {}

      return;
    }

    if (type == 'create_notification') {
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        if (token == null) return;

        await ApiService.createNotification(
          token: token,
          title: data['title'] ?? 'Notifikasi',
          message: data['message'] ?? '',
          icon: data['icon'],
        );
      } catch (_) {}
    }
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF212020),
      body: SafeArea(
        child: Stack(
          children: [
            // CHAT AREA
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
                child: Column(
                  children: [
                    // ===== HEADER =====
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.home,
                                  (route) => false,
                            );
                          },
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Nutrition Chatbot',
                          style: TextStyle(
                            color: Color(0xFF588D6E),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Expanded(
                      child: isLoadingHistory
                          ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF588D6E),
                        ),
                      )
                          : ListView.builder(
                        controller: _scrollController,
                        itemCount:
                        messages.length + (isTyping ? 1 : 0),
                        itemBuilder: (_, i) {
                          if (isTyping && i == messages.length) {
                            return _typingIndicator();
                          }

                          final msg = messages[i];
                          final isUser = msg['from'] == 'user';

                          return Align(
                            alignment: isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 6),
                              padding: const EdgeInsets.all(12),
                              constraints: const BoxConstraints(
                                  maxWidth: 300),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? const Color(0xFF588D6E)
                                    : const Color(0xFF2A2A2A),
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                              child: Text(
                                msg['text'],
                                style: const TextStyle(
                                    color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // INPUT
            Positioned(
              left: 0,
              right: 0,
              bottom: 59,
              child: Container(
                padding: const EdgeInsets.all(12),
                color: const Color(0xFF1E1E1E),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Ketik pesan...',
                          hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.4)),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.08),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(22),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFF588D6E),
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // NAVBAR
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
                            context, AppRoutes.home)),
                    _navIcon(
                        'assets/icons/icon-doc.svg',
                            () => Navigator.pushNamed(
                            context, AppRoutes.tracking)),
                    _navIcon(
                        'assets/icons/logo-star.svg',
                            () => Navigator.pushNamed(
                            context, AppRoutes.home)),
                    _navIcon(
                        'assets/icons/logo-profile2.svg',
                            () => Navigator.pushNamed(
                            context, AppRoutes.chatbot)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _typingIndicator() => const Padding(
    padding: EdgeInsets.all(8),
    child: Text(
      'Bot sedang mengetik...',
      style: TextStyle(color: Colors.white54),
    ),
  );

  Widget _navIcon(String asset, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SvgPicture.asset(
        asset,
        width: 26,
        height: 26,
        colorFilter:
        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
