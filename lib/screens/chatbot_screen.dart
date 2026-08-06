import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class ChatbotScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const ChatbotScreen({super.key, this.onBack});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isTyping = false;
  String? _userName;
  double _todaySpend = 0;

  final List<String> _suggestions = [
    "Check Balance ✨",
    "Savings Tips 💸",
    "Loan Options 💎",
    "Transfer Money 🚀",
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "👋 Hello! I'm Glitter ✨, your AI Assistant. How can I help you with your account today?",
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
      return "✨ Nice to meet you, $_userName! Hope you are having a great day!";
    }

    if (msg.contains("hello") || msg.contains("hi") || msg.contains("hey")) {
      return _userName != null
          ? "👋 Welcome back, $_userName! How can I help you with your vault today?"
          : "👋 Hello! How may I assist you today?";
    }

    if (msg.contains("balance")) {
      return "💰 Check your Dashboard VIP card to view your available balance! GBBT Vault is secure 🔒";
    }

    if (msg.contains("loan")) {
      return "🏦 We offer Personal Loans, Auto Loans, and Home Loans with flexible terms!";
    }

    if (msg.contains("transfer")) {
      return "🔄 Head over to Bank Transfer! LGBTQIA+ members enjoy ₱0 fee transfers!";
    }

    if (msg.contains("save") || msg.contains("savings")) {
      return "📈 Recommended savings strategy: 50% Needs, 30% Wants, 20% Savings & Vault Wealth!";
    }

    if (msg.contains("credit card")) {
      return "💳 Our GBBT Diamond VIP Card features unlimited cashback rewards on everyday purchases!";
    }

    if (msg.contains("thank")) {
      return "😊 You're welcome! Feel free to ask anytime!";
    }

    if (msg.startsWith("save ")) {
      final amount = double.tryParse(msg.replaceAll("save", "").trim());
      if (amount != null) {
        final yearly = amount * 12;
        return "📈 If you save ₱${amount.toStringAsFixed(0)} monthly, you will accumulate ₱${yearly.toStringAsFixed(0)} in 1 year!";
      }
    }
    if (msg.startsWith("spent ")) {
      final amount = double.tryParse(msg.replaceAll("spent", "").trim());
      if (amount != null) {
        _todaySpend += amount;
        return "💸 Expense recorded!\nToday's total spending: ₱${_todaySpend.toStringAsFixed(2)}";
      }
    }

    if (msg.contains("score")) {
      final score = 75 + DateTime.now().second % 25;
      return "👑 Glitter Score: $score/100\n💰 Financial Discipline: Strong\n⚡ Account Status: Active";
    }

    if (msg.startsWith("loan ")) {
      final amount = double.tryParse(msg.replaceAll("loan", "").trim());
      if (amount != null) {
        final monthly = amount / 12;
        return "🏦 Estimated monthly payment:\n₱${monthly.toStringAsFixed(2)} for 12 months.";
      }
    }
    return "🤖 I hear you! For custom VIP account inquiries, GBBT support is available 24/7.";
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
    FunAudioPlayer.playStickerPop();

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
    FunAudioPlayer.playPopupFanfare();

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

  Widget _buildMessage(ChatMessage message, bool isLgbtMode) {
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
              decoration: BoxDecoration(
                gradient: isLgbtMode ? electricRainbowGradient : null,
                color: isLgbtMode ? null : Colors.black,
                shape: BoxShape.circle,
              ),
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
                    gradient: message.isUser
                        ? (isLgbtMode ? electricRainbowGradient : monoDarkGradient)
                        : null,
                    color: message.isUser ? null : Colors.white,
                    borderRadius: BorderRadius.circular(isLgbtMode ? 22 : 12),
                    boxShadow: message.isUser
                        ? (isLgbtMode ? AppShadow.lifted : null)
                        : [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                    border: Border.all(
                      color: message.isUser
                          ? (isLgbtMode ? Colors.white.withOpacity(0.5) : Colors.transparent)
                          : const Color(0xFFCBD5E1),
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: isLgbtMode
                        ? GoogleFonts.fredoka(
                            color: message.isUser ? Colors.white : AppColors.ink,
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: message.isUser ? FontWeight.w600 : FontWeight.w400,
                          )
                        : GoogleFonts.inter(
                            color: message.isUser ? Colors.white : Colors.black,
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: message.isUser ? FontWeight.w600 : FontWeight.w400,
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('hh:mm a').format(message.timestamp),
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: isLgbtMode ? AppColors.inkMuted : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          if (message.isUser) const SizedBox(width: 8),
          if (message.isUser)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isLgbtMode ? AppColors.electricPurple : Colors.black,
                shape: BoxShape.circle,
              ),
              child: const Center(child: Text('👤', style: TextStyle(fontSize: 18))),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestions(bool isLgbtMode) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: _suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              backgroundColor: Colors.white,
              elevation: isLgbtMode ? 2 : 1,
              side: BorderSide(
                color: isLgbtMode ? AppColors.hotPink : const Color(0xFFCBD5E1),
                width: 1.5,
              ),
              label: Text(
                suggestion,
                style: isLgbtMode
                    ? GoogleFonts.fredoka(color: AppColors.hotPink, fontSize: 13, fontWeight: FontWeight.w600)
                    : GoogleFonts.inter(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w600),
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
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
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
                          onPressed: () {
                            if (widget.onBack != null) {
                              widget.onBack!();
                            } else if (Navigator.canPop(context)) {
                              Navigator.of(context).pop();
                            }
                          },
                          icon: Icon(Icons.arrow_back_ios_new, size: 20, color: isLgbtMode ? AppColors.ink : Colors.black),
                          style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                        ),
                        const SizedBox(width: 12),
                        const RainbowShimmerText(text: 'Glitter Bot 🤖', fontSize: 24),
                        const Spacer(),
                        InteractiveSticker(
                          text: isLgbtMode ? '✨ 24/7 SASS' : 'AI ASSISTANT',
                          rotateAngle: isLgbtMode ? -0.04 : 0.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildSuggestions(isLgbtMode),

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
                                  decoration: BoxDecoration(
                                    gradient: isLgbtMode ? electricRainbowGradient : null,
                                    color: isLgbtMode ? null : Colors.black,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(child: Text('🤖', style: TextStyle(fontSize: 16))),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  isLgbtMode ? "Glitter is cooking up tea... ✨" : "Glitter is typing...",
                                  style: GoogleFonts.inter(
                                    color: isLgbtMode ? AppColors.hotPink : Colors.black,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildMessage(_messages[index], isLgbtMode);
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
                              hintText: isLgbtMode ? "Ask Glitter anything, bestie..." : "Ask Glitter anything...",
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 54,
                          width: 54,
                          decoration: BoxDecoration(
                            gradient: isLgbtMode ? electricRainbowGradient : null,
                            color: isLgbtMode ? null : Colors.black,
                            shape: BoxShape.circle,
                            boxShadow: isLgbtMode ? AppShadow.lifted : null,
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
      },
    );
  }
}