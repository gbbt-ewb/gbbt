import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../shared_widgets.dart';

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
    'Soft Launch Legend ✨ — Quietly excellent & extra',
    'Certified Bestie Material 💖 — Loyalty stat: MAXED OUT!',
    'Over-The-Top Bongga Queen 💎 — 1000% Extra Fabulous',
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
      body: BonggaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                const Spacer(),

                BonggaCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const RainbowMark(size: 100),
                      const SizedBox(height: 20),

                      const InteractiveSticker(text: '✨ AI ENERGY SCANNER', rotateAngle: -0.05),
                      const SizedBox(height: 12),

                      Text(
                        'GBBT Vibe Analysis 🔮',
                        style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 24, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pure wholesome energy scan. No judgment, just pure main character aura. 💖',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 13.5, height: 1.4),
                      ),
                      const SizedBox(height: 28),

                      if (_scanning)
                        Column(
                          children: [
                            const CircularProgressIndicator(
                              strokeWidth: 4,
                              valueColor: AlwaysStoppedAnimation(AppColors.hotPink),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Scanning aura & extra vibes... ✨',
                              style: GoogleFonts.fredoka(color: AppColors.hotPink, fontSize: 15),
                            ),
                          ],
                        ),

                      if (_result != null)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: electricRainbowGradient,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: AppShadow.lifted,
                          ),
                          child: Column(
                            children: [
                              const Text('🎉', style: TextStyle(fontSize: 32)),
                              const SizedBox(height: 6),
                              Text(
                                _result!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 17,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),

                GradientButton(
                  label: _scanning ? 'Scanning Vibes...' : 'Scan My Vibe ✨',
                  icon: Icons.auto_awesome_rounded,
                  isLoading: _scanning,
                  onPressed: _scan,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
