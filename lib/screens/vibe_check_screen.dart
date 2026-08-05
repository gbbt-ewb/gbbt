import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../shared_widgets.dart';

// Note: this screen intentionally does NOT use the device camera.
// It's a silly, wholesome, purely-random vibe generator — no real
// image analysis, and nothing here is wired to Aura Exchange, so
// nobody's "worth" is ever tied to how they look.
class VibeCheckScreen extends StatefulWidget {
  const VibeCheckScreen({super.key});

  @override
  State<VibeCheckScreen> createState() => _VibeCheckScreenState();
}

class _VibeCheckScreenState extends State<VibeCheckScreen> {
  final Random _random = Random();

  bool _scanning = false;
  String? _result;
  int _progress = 0;
  int _score = 0;

  static const List<String> _results = [
    'Certified Icon 💅 — 100% Main Character Energy',
    'Unbothered Royalty 👑 — Serving looks and interest rates',
    '110% Unicorn Energy 🦄 — Immaculate vibes detected',
    'Chaotic Good Rainbow 🌈 — Unpredictable but iconic',
    'Soft Launch Legend ✨ — Quietly excellent & extra',
    'Certified Bestie Material 💖 — Loyalty stat: MAXED OUT!',
    'Too Fabulous For This App 🔥 — Elite Aura Detected',
    'Over-The-Top Bongga Queen 💎 — 1000% Extra Fabulous',
  ];

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _result = null;
      _progress = 0;
    });

    while (_progress < 100) {
      await Future.delayed(const Duration(milliseconds: 35));
      if (!mounted) return;
      setState(() => _progress += 4);
    }

    if (!mounted) return;
    final score = 60 + _random.nextInt(41);
    final resultText = _results[_random.nextInt(_results.length)];

    setState(() {
      _score = score;
      _result = resultText;
      _scanning = false;
    });

    showOaVibeDialog(context, score: score, result: resultText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BonggaBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.ink),
                      style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                    ),
                    const SizedBox(width: 12),
                    const RainbowShimmerText(text: 'Vibe Check ✨', fontSize: 24),
                  ],
                ),
                const SizedBox(height: 20),

                BonggaCard(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      const RainbowMark(size: 84),
                      const SizedBox(height: 18),
                      const InteractiveSticker(text: '✨ 100% RANDOM, 0% SERIOUS', rotateAngle: -0.05),
                      const SizedBox(height: 12),
                      Text(
                        'GBBT AI Vibe Check ✨',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Not a real scanner, no camera, no looks involved — just a silly vibe generator. 😎",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 13.5),
                      ),
                      const SizedBox(height: 24),

                      // Decorative animated orb (replaces the old camera preview)
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: electricRainbowGradient,
                                boxShadow: AppShadow.neonGlow,
                              ),
                            ),
                            Container(
                              width: 190,
                              height: 190,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                            ),
                            if (_scanning)
                              TweenAnimationBuilder(
                                tween: Tween<double>(begin: 0, end: 1),
                                duration: const Duration(seconds: 1),
                                onEnd: () {},
                                builder: (_, value, child) {
                                  return Transform.rotate(
                                    angle: value * 6.28 * 3,
                                    child: const Icon(Icons.auto_awesome_rounded, size: 64, color: AppColors.hotPink),
                                  );
                                },
                              )
                            else
                              const Icon(Icons.auto_awesome_rounded, size: 64, color: AppColors.electricPurple),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (_scanning) ...[
                        Text(
                          'Scanning Aura...',
                          style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: LinearProgressIndicator(
                            value: _progress / 100,
                            minHeight: 12,
                            backgroundColor: AppColors.line,
                            valueColor: const AlwaysStoppedAnimation(AppColors.hotPink),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '$_progress%',
                          style: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.hotPink),
                        ),
                      ],

                      if (_result != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            gradient: electricRainbowGradient,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: AppShadow.lifted,
                          ),
                          child: Column(
                            children: [
                              Text('$_score%', style: GoogleFonts.fredoka(color: Colors.white, fontSize: 44, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 4),
                              Text(
                                'VIBE SCORE',
                                style: GoogleFonts.fredoka(color: Colors.white.withOpacity(0.85), letterSpacing: 2, fontWeight: FontWeight.w700, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _result!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                GradientButton(
                  label: _scanning ? 'Scanning Vibes...' : 'Scan My Vibe ✨',
                  icon: Icons.auto_awesome_rounded,
                  isLoading: _scanning,
                  onPressed: _scanning ? null : _scan,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}