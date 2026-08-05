import 'dart:math';
import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../shared_widgets.dart';

// Note: this is the reframed version of the "pretty or ugly" idea from
// the brief. It keeps the joke ("silly AI scan") but the output is a
// random wholesome vibe label instead of an appearance judgment — no
// camera, no real image analysis, nothing that could actually sting.
class VibeCheckScreen extends StatefulWidget {
  const VibeCheckScreen({super.key});

  @override
  State<VibeCheckScreen> createState() => _VibeCheckScreenState();
}

class _VibeCheckScreenState extends State<VibeCheckScreen> {
  bool _scanning = false;
  String? _result;
  final _random = Random();

  static const _results = [
    'Certified Icon 💅 — 100% Main Character Energy',
    'Unbothered Royalty 👑 — Serving looks and interest rates',
    '110% Unicorn Energy 🦄 — Immaculate vibes detected',
    'Chaotic Good Rainbow 🌈 — Unpredictable but iconic',
    'Soft Launch Legend ✨ — Quietly excellent',
    'Certified Bestie Material 💖 — Loyalty stat: maxed out',
  ];

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _result = null;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _scanning = false;
      _result = _results[_random.nextInt(_results.length)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(backgroundColor: AppColors.cream, elevation: 0, title: const Text('Vibe Check'), foregroundColor: AppColors.ink),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const RainbowMark(size: 96),
              const SizedBox(height: 24),
              Text('GBBT AI Vibe Check ✨', style: Theme.of(context).textTheme.headlineSmall, textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Text(
                'Not a real scanner — just a silly, wholesome vibe generator. No looks, just energy. 💫',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.inkMuted),
              ),
              const SizedBox(height: 32),
              if (_scanning) const CircularProgressIndicator(color: AppColors.primary),
              if (_result != null)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(gradient: rainbowGradient, borderRadius: BorderRadius.circular(20)),
                  child: Text(_result!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              const SizedBox(height: 32),
              GradientButton(label: _scanning ? 'Scanning...' : 'Scan My Vibe', isLoading: _scanning, onPressed: _scan),
            ],
          ),
        ),
      ),
    );
  }
}
