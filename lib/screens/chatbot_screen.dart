import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_theme.dart';
import '../models.dart';

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
    "Check Balance",
    "Savings Tips",
    "Loan Options",
    "Transfer Money",
  ];

  final List<ChatMessage> _messages = [
    ChatMessage(
      text:
          "👋 Hi! I'm Glitter, your GBBT Bank assistant. How can I help you today?",
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
      return "✨ Nice to meet you, $_userName!";
    }

    if (msg.contains("hello") ||
        msg.contains("hi") ||
        msg.contains("hey")) {
      return _userName != null
          ? "👋 Welcome back, $_userName!"
          : "👋 Hello! How may I help you today?";
    }

    if (msg.contains("balance")) {
      return "💰 For security reasons, I can't view your account balance. Please check the Dashboard section.";
    }

    if (msg.contains("loan")) {
      return "🏦 We offer Personal Loans, Auto Loans, and Home Loans. Which one are you interested in?";
    }

    if (msg.contains("transfer")) {
      return "🔄 You can transfer funds through the Payments section of the app.";
    }

    if (msg.contains("save") || msg.contains("savings")) {
      return "📈 A useful savings strategy is the 50/30/20 rule: 50% needs, 30% wants, and 20% savings.";
    }

    if (msg.contains("credit card")) {
      return "💳 We offer Cashback, Rewards, and Travel Credit Cards. Would you like to compare them?";
    }

    if (msg.contains("investment")) {
      return "📊 Consider diversifying your investments across multiple asset classes to manage risk.";
    }

    if (msg.contains("thank")) {
      return "😊 You're welcome! Happy to help.";
    }

    return "🤖 I understand your question. For more specific account-related concerns, please contact GBBT customer support.";
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
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser)
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.purple,
              child: Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 18,
              ),
            ),

          if (!message.isUser) const SizedBox(width: 8),

          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: message.isUser ? rainbowGradient : null,
                    color: message.isUser ? null : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: AppShadow.soft,
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color:
                          message.isUser ? Colors.white : AppColors.ink,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('hh:mm a')
                      .format(message.timestamp),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          if (message.isUser) const SizedBox(width: 8),

          if (message.isUser)
            const CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 18,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSuggestions() {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: _suggestions.map((suggestion) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(suggestion),
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
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        title: const Text(
          'GBBT Chatbot',
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSuggestions(),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    _messages.length + (_isTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isTyping &&
                      index == _messages.length) {
                    return const Padding(
                      padding: EdgeInsets.only(
                        left: 12,
                        top: 8,
                        bottom: 8,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.purple,
                            child: Icon(
                              Icons.smart_toy,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Glitter is typing...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return _buildMessage(
                    _messages[index],
                  );
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
                        hintText: "Type a message...",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Container(
                    decoration: const BoxDecoration(
                      gradient: rainbowGradient,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                      onPressed: _send,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}