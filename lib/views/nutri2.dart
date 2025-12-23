import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../routes/app_routes.dart';

class Nutritionist2 extends StatefulWidget {
  const Nutritionist2({super.key});

  // ukuran figma
  static const double _designW = 393;
  static const double _designH = 852;

  @override
  State<Nutritionist2> createState() => _Nutritionist2State();
}

class _Nutritionist2State extends State<Nutritionist2> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // ====== SVG ICON PATHS (TINGGAL GANTI) ======
  // kiri (attach/plus)
  final String _leftCircleSvg = 'assets/icons/chat-attach.svg';

  // kanan 1 (mic/camera)
  final String _rightCircle1Svg = 'assets/icons/chat-mic.svg';

  // kanan 2 (send)
  final String _rightCircle2Svg = 'assets/icons/chat-send1.svg';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // scaling biar mirip figma di HP
    final sx = size.width / Nutritionist2._designW;
    final sy = size.height / Nutritionist2._designH;
    final s = sx < sy ? sx : sy;

    double w(double v) => v * s;
    double h(double v) => v * s;

    Widget svgIcon({
      required String assetPath,
      required double size,
      Color? color,
    }) {
      return SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
        placeholderBuilder: (_) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.yellow,
            borderRadius: BorderRadius.circular(w(6)),
          ),
        ),
      );
    }

    void goBack() {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        // fallback kalau page ini jadi entry
        Navigator.pushReplacementNamed(context, AppRoutes.nutri1); // ganti kalau nama route beda
      }
    }

    // ===== BUBBLE BUILDER (rapih, ga perlu rotate) =====
    Widget chatBubble({
      required String text,
      required bool isMe,
      double? width,
      double? minHeight,
    }) {
      final bubbleW = width ?? w(254);
      final bubbleMinH = minHeight ?? h(50);

      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(minHeight: bubbleMinH, maxWidth: bubbleW),
          padding: EdgeInsets.symmetric(horizontal: w(18), vertical: h(12)),
          decoration: BoxDecoration(
            color: isMe ? const Color(0xFF588D6E) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(w(30)),
              topRight: Radius.circular(w(30)),
              bottomLeft: Radius.circular(isMe ? w(30) : w(8)),
              bottomRight: Radius.circular(isMe ? w(8) : w(30)),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF232222),
              fontSize: w(14),
              fontFamily: 'League Spartan',
              fontWeight: FontWeight.w300,
              height: 1.1,
            ),
          ),
        ),
      );
    }

    Widget timeText(String t, {required bool isMe}) {
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(top: h(6)),
          child: Text(
            t,
            style: TextStyle(
              color: Colors.white,
              fontSize: w(12),
              fontFamily: 'League Spartan',
              fontWeight: FontWeight.w300,
              height: 1.17,
            ),
          ),
        ),
      );
    }

    // ====== CIRCLE SVG BUTTON TEMPLATE (BULETAN BAWAH) ======
    // tinggal ganti svg path di atas, done.
    Widget circleSvgButton({
      required String svgPath,
      VoidCallback? onTap,
      double? sizeOverride,
      double? iconSizeOverride,
      Color? iconColor,
    }) {
      final btnSize = sizeOverride ?? w(25);
      final iconSize = iconSizeOverride ?? w(14);

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: btnSize,
          height: btnSize,
          decoration: BoxDecoration(
            color: const Color(0xFF232222),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF232222), width: w(1.25)),
          ),
          alignment: Alignment.center,
          child: svgIcon(
            assetPath: svgPath,
            size: iconSize,
            color: iconColor ?? Colors.white, // default putih biar kontras
          ),
        ),
      );
    }

    void onSend() {
      final text = _controller.text.trim();
      if (text.isEmpty) return;

      // NOTE: di UI ini masih statis, jadi sementara cuma clear + tetap fokus
      // kalau mau beneran nambah chat dynamic, bilang aja—aku bikinin list message-nya
      _controller.clear();
      _focusNode.requestFocus();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF212020),

      // NAVBAR TEMPLATE (persis yang kamu kasih)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: h(30) + h(27),
          color: const Color(0xFF588D6E),
          child: Column(
            children: [
              SizedBox(height: h(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: svgIcon(
                      assetPath: 'assets/icons/logo-home2.svg',
                      size: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.tracking),
                    child: svgIcon(
                      assetPath: 'assets/icons/icon-doc.svg',
                      size: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.home),
                    child: svgIcon(
                      assetPath: 'assets/icons/logo-star.svg',
                      size: w(26),
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
                    child: svgIcon(
                      assetPath: 'assets/icons/logo-profile2.svg',
                      size: w(26),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              // ===== HEADER (back + avatar + name) =====
              Padding(
                padding: EdgeInsets.only(left: w(18), right: w(18), top: h(10)),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: goBack,
                      child: Container(
                        width: w(36),
                        height: w(36),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: w(16),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(width: w(10)),
                    Container(
                      width: w(45),
                      height: w(42),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage("assets/images/fruits.png"),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(w(212.5)),
                      ),
                    ),
                    SizedBox(width: w(10)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'jeo',
                          style: TextStyle(
                            color: const Color(0xFF588D6E),
                            fontSize: w(20),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: h(2)),
                        Text(
                          "I'm here to assist you",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: w(15),
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: h(10)),

              // ===== CHAT AREA (scrollable) =====
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: w(22), vertical: h(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      chatBubble(text: "Hello!", isMe: true, width: w(76), minHeight: h(33)),
                      timeText("09:00 AM", isMe: true),

                      SizedBox(height: h(14)),

                      chatBubble(text: "How can I help you today?", isMe: false, width: w(254), minHeight: h(59)),
                      timeText("09:00 AM", isMe: false),

                      SizedBox(height: h(14)),

                      chatBubble(
                        text:
                        "Can you tell me more about your current eating habits and any specific health goals you’d like to achieve?",
                        isMe: false,
                        width: w(254),
                        minHeight: h(59),
                      ),
                      timeText("09:00 AM", isMe: false),

                      SizedBox(height: h(14)),

                      chatBubble(text: "Sure", isMe: true, width: w(76), minHeight: h(33)),
                      timeText("09:03 AM", isMe: true),

                      SizedBox(height: h(14)),

                      chatBubble(
                        text:
                        "I usually skip breakfast and eat a lot of snacks throughout the day. My main goal is to lose weight and feel more energetic.",
                        isMe: true,
                        width: w(254),
                        minHeight: h(76),
                      ),
                      timeText("09:03 AM", isMe: true),

                      SizedBox(height: h(14)),

                      chatBubble(
                        text:
                        "Thank you for sharing that! To start, we can focus on incorporating a balanced breakfast to give you sustained energy and planning healthier snack options to support your weight loss goals. Would you be open to trying some simple meal ideas and a snack schedule?",
                        isMe: false,
                        width: w(254),
                        minHeight: h(119),
                      ),
                      timeText("09:05 AM", isMe: false),

                      SizedBox(height: h(14)),
                    ],
                  ),
                ),
              ),

              // ===== INPUT BAR (textfield real + svg icon buttons) =====
              Padding(
                padding: EdgeInsets.only(left: w(18), right: w(18), bottom: h(12)),
                child: Container(
                  height: h(61),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(w(13)),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: w(10)),
                  child: Row(
                    children: [
                      // LEFT SVG CIRCLE
                      circleSvgButton(
                        svgPath: _leftCircleSvg,
                        onTap: () {
                          // TODO: attach action
                        },
                      ),
                      SizedBox(width: w(10)),

                      // TextField
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.send,
                          style: TextStyle(
                            color: const Color(0xFF252525),
                            fontSize: w(12),
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                            hintText: "Write Here...",
                            hintStyle: TextStyle(
                              color: const Color(0xFF252525).withOpacity(0.6),
                              fontSize: w(12),
                              fontFamily: 'League Spartan',
                              fontWeight: FontWeight.w100,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.only(bottom: h(2)),
                          ),
                          onSubmitted: (_) => onSend(),
                        ),
                      ),

                      SizedBox(width: w(10)),

                      // RIGHT SVG CIRCLE 1
                      circleSvgButton(
                        svgPath: _rightCircle1Svg,
                        onTap: () {
                          // TODO: mic/camera action
                        },
                      ),
                      SizedBox(width: w(8)),

                      // RIGHT SVG CIRCLE 2 (SEND)
                      circleSvgButton(
                        svgPath: _rightCircle2Svg,
                        onTap: onSend,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
