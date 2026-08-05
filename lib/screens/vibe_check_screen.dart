import 'dart:html' as html;
import 'dart:math';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';

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
    'Certified Icon 💅',
    'Unbothered Royalty 👑',
    '110% Unicorn Energy 🦄',
    'Chaotic Good Rainbow 🌈',
    'Soft Launch Legend ✨',
    'Certified Bestie Material 💖',
    'Main Character Energy 🎬',
    'Too Fabulous For This App 🔥',
    'Legendary Aura Detected ⭐',
    'Elite Vibes Unlocked 🚀',
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

      final stream =
          await html.window.navigator.mediaDevices!.getUserMedia({
        'video': true,
        'audio': false,
      });

      _videoElement.srcObject = stream;

      ui.platformViewRegistry.registerViewFactory(
        'webcam-view',
        (int viewId) => _videoElement,
      );

      setState(() {
        _cameraReady = true;
      });
    } catch (e) {
      debugPrint('Camera Error: $e');
    }
  }

  Future<void> _scan() async {
    setState(() {
      _scanning = true;
      _result = null;
      _progress = 60;
    });

    while (_progress < 100) {
      await Future.delayed(const Duration(milliseconds: 60));

      if (!mounted) return;

      setState(() {
        _progress++;
      });
    }

    if (!mounted) return;

    setState(() {
      _score = 60 + _random.nextInt(41);
      _result = _results[_random.nextInt(_results.length)];
      _scanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Vibe Check'),
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const RainbowMark(size: 96),

              const SizedBox(height: 24),

              Text(
                'GBBT AI Vibe Check ✨',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),

              const SizedBox(height: 12),

              Text(
                'Live webcam + totally scientific vibe analysis 😎',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.inkMuted),
              ),

              const SizedBox(height: 30),

              Container(
                width: 260,
                height: 260,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _cameraReady
                    ? const HtmlElementView(
                        viewType: 'webcam-view',
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),

              const SizedBox(height: 30),

              if (_scanning)
                Column(
                  children: [
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(seconds: 1),
                      builder: (_, value, child) {
                        return Transform.rotate(
                          angle: value * 6.28,
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 70,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'AI Scanning...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),

                    const SizedBox(height: 16),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: _progress / 100,
                        minHeight: 12,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      '$_progress%',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

              if (_result != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: rainbowGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '$_score%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        'VIBE SCORE',
                        style: TextStyle(
                          color: Colors.white70,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        _result!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              GradientButton(
                label: _scanning ? 'Scanning...' : 'Scan My Vibe',
                isLoading: _scanning,
                onPressed: _scanning ? null : _scan,
              ),
            ],
          ),
        ),
      ),
    );
  }
}