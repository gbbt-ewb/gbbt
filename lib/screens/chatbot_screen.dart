import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  String? _userName;

  final List<String> _suggestions = [
    "Check Balance ✨",
    "Savings Tips 💸",
    "Loan Options 💎",
    "Transfer Money 🚀",
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "👋 Yasss queen! I'm Glitter ✨, your sassy GBBT AI Assistant. What financial tea are we spilling today? 💅",
      isUser: false,
      timestamp: DateTime.now(),
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _getBotResponse(String text) {
    final msg = text.toLowerCase();

    if (msg.startsWith("my name is")) {
      _userName = text.substring(10).trim();
      return "✨ Slay! Nice to meet you, $_userName! You look stunning today! 👑";
    }

    if (msg.contains("hello") || msg.contains("hi") || msg.contains("hey")) {
      return _userName != null
          ? "👋 Welcome back, $_userName! How can Glitter help your vault shine? ✨"
          : "👋 Hello gorgeous! How may I assist you today? 🌈";
    }

    if (msg.contains("balance")) {
      return "💰 Honey, check your Dashboard VIP card to reveal your millions! GBBT Vault is secure 🔒✨";
    }

    if (msg.contains("loan")) {
      return "🏦 We offer Personal Loans, Glamour Auto Loans, and Mansion Loans! All with 100% Sass & 0% Judgment 💖";
    }

    if (msg.contains("transfer")) {
      return "🔄 Head over to Bank Transfer! LGBTQIA+ members send money with ₱0 fees forever! ⚡💅";
    }

    if (msg.contains("save") || msg.contains("savings")) {
      return "📈 Rule #1 of GBBT Savings: 50% Needs, 30% Glamour & Wants, 20% Vault Wealth! 💎";
    }

    if (msg.contains("credit card")) {
      return "💳 Our GBBT Diamond VIP Card comes with unlimited cashback on iced coffee & fabulous outfits ☕💅";
    }

    if (msg.contains("thank")) {
      return "😊 Any time, queen! Stay fabulous & keep saving! 💖✨";
    }

    return "🤖 Honey, I hear you loud and clear! For custom VIP requests, GBBT concierge is at your service 24/7 ✨";
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          isUser: true,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = true;
    });

    _controller.clear();
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() {
      _messages.add(
        ChatMessage(
          text: _getBotResponse(text),
          isUser: false,
          timestamp: DateTime.now(),
        ),
      );
      _isTyping = false;
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
      );
    });
  }

  Widget _buildMessage(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(gradient: electricRainbowGradient, shape: BoxShape.circle),
              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 18))),
            ),
          if (!message.isUser) const SizedBox(width: 8),

          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: message.isUser ? electricRainbowGradient : null,
                    color: message.isUser ? null : Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: message.isUser ? AppShadow.lifted : AppShadow.soft,
                    border: Border.all(
                      color: message.isUser ? Colors.white.withOpacity(0.5) : AppColors.line,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: GoogleFonts.inter(
                      color: message.isUser ? Colors.white : AppColors.ink,
                      fontSize: 14,
                      height: 1.4,
                      fontWeight: message.isUser ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: GoogleFonts.inter(fontSize: 10.5, color: AppColors.inkMuted),
                ),
              ],
            ),
          ),

          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser)
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(color: AppColors.electricPurple, shape: BoxShape.circle),
              child: const Center(child: Text('👑', style: TextStyle(fontSize: 18))),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              backgroundColor: Colors.white.withOpacity(0.9),
              elevation: 2,
              side: const BorderSide(color: AppColors.hotPink, width: 1.5),
              label: Text(
                suggestion,
                style: GoogleFonts.fredoka(color: AppColors.hotPink, fontSize: 13, fontWeight: FontWeight.w600),
              ),
              onPressed: () {
                _controller.text = suggestion;
                _send();
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BonggaBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.ink),
                      style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                    ),
                    const SizedBox(width: 12),
                    const RainbowShimmerText(text: 'Glitter Bot 🤖', fontSize: 24),
                    const Spacer(),
                    const InteractiveSticker(text: '✨ 24/7 SASS', rotateAngle: -0.04),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              _buildSuggestions(),

              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (_isTyping && index == _messages.length) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: const BoxDecoration(gradient: electricRainbowGradient, shape: BoxShape.circle),
                              child: const Center(child: Text('🤖', style: TextStyle(fontSize: 16))),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Glitter is cooking up tea... ✨",
                              style: GoogleFonts.inter(color: AppColors.hotPink, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      );
                    }
                    return _buildMessage(_messages[index]);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _send(),
                        decoration: InputDecoration(
                          hintText: "Ask Glitter anything, bestie...",
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.95),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        gradient: electricRainbowGradient,
                        shape: BoxShape.circle,
                        boxShadow: AppShadow.lifted,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white, size: 24),
                        onPressed: _send,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}