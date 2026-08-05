import 'dart:math';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _random = Random();

  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: "Hiii! I'm Glitter, your GBBT Bank assistant. Ask me anything (finance-related or not, I don't judge). 🌈",
      isUser: false,
    ),
  ];

  // Canned rule-based responses — no real AI/API calls involved.
  static const _canned = [
    "That's above my pay grade, and I don't even get paid, so...",
    'Have you tried turning your wallet off and on again?',
    "Girl, that's between you and your bank statement.",
    'Financial tip: touch grass, then touch savings account.',
    "I'd help more but I'm just a mock chatbot with no real AI. Iconic, honestly.",
    'Bold of you to assume I know that. 💅',
    'Checking... checking... yep, still fabulous.',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _messages.add(ChatMessage(text: _canned[_random.nextInt(_canned.length)], isUser: false));
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(backgroundColor: AppColors.cream, elevation: 0, title: const Text('GBBT Chatbot'), foregroundColor: AppColors.ink),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final m = _messages[index];
                  return Align(
                    alignment: m.isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
                      decoration: BoxDecoration(
                        gradient: m.isUser ? rainbowGradient : null,
                        color: m.isUser ? null : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: AppShadow.soft,
                      ),
                      child: Text(m.text, style: TextStyle(color: m.isUser ? Colors.white : AppColors.ink, fontSize: 13.5)),
                    ),
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
                        hintText: 'Type a message...',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(gradient: rainbowGradient, shape: BoxShape.circle),
                    child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white), onPressed: _send),
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
