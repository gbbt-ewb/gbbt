import 'dart:html' as html;
import 'dart:math';
import 'dart:ui_web' as ui;

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
  final Random _random = Random();

  bool _cameraReady = false;
  bool _scanning = false;
  String? _result;

  int _progress = 0;
  int _score = 0;

  late html.VideoElement _videoElement;

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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..muted = true
        ..style.objectFit = 'cover';

      final stream = await html.window.navigator.mediaDevices!.getUserMedia({
        'video': true,
        'audio': false,
      });

      _videoElement.srcObject = stream;

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        'webcam-view',
        (int viewId) => _videoElement,
      );

      if (mounted) {
        setState(() {
          _cameraReady = true;
        });
      }
    } catch (e) {
      debugPrint('Camera Error: $e');
    }
  }

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

    // Trigger OA Vibe Scan Explosive Popup + Party Poppers + Funny Sound!
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
                      const InteractiveSticker(text: '✨ AI ENERGY WEBCAM SCANNER', rotateAngle: -0.05),
                      const SizedBox(height: 12),
                      Text(
                        'GBBT AI Vibe Check ✨',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Live webcam preview + 100% scientific aura analysis 😎',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 13.5),
                      ),
                      const SizedBox(height: 24),

                      // LIVE WEBCAM VIEWFINDER
                      Container(
                        width: 250,
                        height: 250,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: AppColors.hotPink, width: 3.5),
                          boxShadow: AppShadow.neonGlow,
                        ),
                        child: _cameraReady
                            ? const HtmlElementView(
                                viewType: 'webcam-view',
                              )
                            : const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(color: AppColors.hotPink),
                                    SizedBox(height: 12),
                                    Text(
                                      'Starting Camera... 📸',
                                      style: TextStyle(color: AppColors.inkMuted, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                      const SizedBox(height: 24),

                      if (_scanning) ...[
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 1),
                          duration: const Duration(seconds: 1),
                          onEnd: () {},
                          builder: (_, value, child) {
                            return Transform.rotate(
                              angle: value * 6.28 * 3,
                              child: const Icon(Icons.auto_awesome_rounded, size: 48, color: AppColors.hotPink),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Scanning Camera Aura...',
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