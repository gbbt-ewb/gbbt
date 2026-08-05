import 'dart:convert';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

// ═══════════════════════════════════════════════════════════
// APP MODE CONTROLLER — LGBT+ Mode (Bongga Rainbow) vs Straight Mode (Strict Black & White Flat UI)
// ═══════════════════════════════════════════════════════════
class AppModeController extends ValueNotifier<bool> {
  AppModeController._() : super(true); // true = LGBT+ Mode (Default Rainbow), false = Straight Mode (Strict Black & White)
  static final instance = AppModeController._();

  bool get isLgbtMode => value;
  bool get isStraightMode => !value;

  void toggleMode() {
    value = !value;
    if (value) {
      FunAudioPlayer.playStickerPop();
    } else {
      FunAudioPlayer.playPassSound();
    }
  }
}

// ═══════════════════════════════════════════════════════════
// MODE TOGGLE SWITCH WIDGET (LGBT+ Mode vs Straight Mode)
// ═══════════════════════════════════════════════════════════
class AppModeToggleSwitch extends StatelessWidget {
  const AppModeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return GestureDetector(
          onTap: () => AppModeController.instance.toggleMode(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              gradient: isLgbtMode ? electricRainbowGradient : null,
              color: isLgbtMode ? null : const Color(0xFF111111),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isLgbtMode ? Colors.white : Colors.black,
                width: 1.5,
              ),
              boxShadow: isLgbtMode
                  ? AppShadow.soft
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isLgbtMode ? '🌈 LGBT+ MODE' : '👔 STRAIGHT MODE',
                  style: isLgbtMode
                      ? GoogleFonts.fredoka(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        )
                      : GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                ),
                const SizedBox(width: 6),
                Icon(
                  isLgbtMode ? Icons.auto_awesome_rounded : Icons.business_center_rounded,
                  color: isLgbtMode ? AppColors.neonGold : Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// FUNNY CARTOON AUDIO SYNTHESIZER 🎵🤪
// Generates funny, humorous sound effects for stickers & popups!
// ═══════════════════════════════════════════════════════════
class FunAudioPlayer {
  static void _playPcmWav(List<int> samples, int sampleRate) {
    try {
      final wavHeader = <int>[
        // RIFF header
        0x52, 0x49, 0x46, 0x46,
        (36 + samples.length) & 0xFF,
        ((36 + samples.length) >> 8) & 0xFF,
        ((36 + samples.length) >> 16) & 0xFF,
        ((36 + samples.length) >> 24) & 0xFF,
        0x57, 0x41, 0x56, 0x45,
        // fmt chunk
        0x66, 0x6D, 0x74, 0x20,
        16, 0, 0, 0, // chunk length
        1, 0, // PCM format
        1, 0, // 1 channel
        sampleRate & 0xFF,
        (sampleRate >> 8) & 0xFF,
        (sampleRate >> 16) & 0xFF,
        (sampleRate >> 24) & 0xFF,
        sampleRate & 0xFF,
        (sampleRate >> 8) & 0xFF,
        (sampleRate >> 16) & 0xFF,
        (sampleRate >> 24) & 0xFF,
        1, 0, // block align
        8, 0, // 8 bits per sample
        // data chunk
        0x64, 0x61, 0x74, 0x61,
        samples.length & 0xFF,
        (samples.length >> 8) & 0xFF,
        (samples.length >> 16) & 0xFF,
        (samples.length >> 24) & 0xFF,
      ];
      final bytes = [...wavHeader, ...samples];
      final b64 = base64Encode(bytes);
      final audio = html.AudioElement('data:audio/wav;base64,$b64');
      audio.play();
    } catch (e) {
      debugPrint('PCM Audio Play Error: $e');
    }
  }

  /// Interactive Sticker Click: Funny Cartoon Boing-Wobble! 🤪 spring sound
  static void playStickerPop() {
    const rate = 16000;
    const numSamples = 3200; // 0.2s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      final wobble = math.sin(t * 85.0) * 180.0;
      final freq = 260.0 + wobble + (t * 2200.0);
      final amplitude = (1.0 - (t / 0.2)).clamp(0.0, 1.0);
      final val = (math.sin(t * freq * 2 * math.pi) * 127.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }

  /// OA Fanfare / Popup Explosion: Funny Ka-Ching + Celebration Chime! 💸🎉
  static void playPopupFanfare() {
    const rate = 16000;
    const numSamples = 6400; // 0.4s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      double freq = 523.25; // C5
      if (t > 0.08) freq = 659.25; // E5
      if (t > 0.16) freq = 783.99; // G5
      if (t > 0.24) freq = 1046.50 + math.sin(t * 60) * 100; // C6 with funny vibrato
      final amplitude = (1.0 - (t / 0.4)).clamp(0.0, 1.0);
      final val = ((math.sin(t * freq * 2 * math.pi) + math.sin(t * 2400 * 2 * math.pi) * 0.4) * 90.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }

  /// Love Match Buzz: Funny Kiss-Squeak Vibrato! 💋💖
  static void playLoveMatchSound() {
    const rate = 16000;
    const numSamples = 4800; // 0.3s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      final freq = 500.0 + math.sin(t * 140.0) * 320.0;
      final amplitude = (1.0 - (t / 0.3)).clamp(0.0, 1.0);
      final val = (math.sin(t * freq * 2 * math.pi) * 127.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }

  /// Sassy Rejection Pass: Funny Comedy Fail "Wha-wha-whaa-wump!" 🎺💔
  static void playPassSound() {
    const rate = 16000;
    const numSamples = 6400; // 0.4s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      double freq = 340.0;
      if (t > 0.1) freq = 300.0;
      if (t > 0.2) freq = 260.0;
      if (t > 0.3) freq = 180.0 - (t * 200.0);
      final amplitude = (1.0 - (t / 0.4)).clamp(0.0, 1.0);
      final phase = (t * freq) % 1.0;
      final val = ((phase - 0.5) * 200.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }
}

// ═══════════════════════════════════════════════════════════
// ANIMATED "BONGGA" BACKGROUND — Dynamically Switches for LGBT+ vs Straight Mode
// ═══════════════════════════════════════════════════════════
class BonggaBackground extends StatefulWidget {
  final Widget child;
  final bool darkOverlay;
  const BonggaBackground({super.key, required this.child, this.darkOverlay = false});

  @override
  State<BonggaBackground> createState() => _BonggaBackgroundState();
}

class _BonggaBackgroundState extends State<BonggaBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_FloatingStickerData> _lgbtStickers = [];
  final math.Random _random = math.Random(42);

  static const List<String> _rainbowEmojis = [
    '✨', '🦄', '💖', '👑', '🌈', '💸', '💅', '💎', '🌟', '⚡', '🔥', '🎉'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat();

    for (int i = 0; i < 16; i++) {
      _lgbtStickers.add(_FloatingStickerData(
        emoji: _rainbowEmojis[i % _rainbowEmojis.length],
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        speedX: (_random.nextDouble() - 0.5) * 0.15,
        speedY: (_random.nextDouble() - 0.5) * 0.15,
        scale: 0.7 + _random.nextDouble() * 0.7,
        rotation: (_random.nextDouble() - 0.5) * 0.6,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: isLgbtMode
                    ? (widget.darkOverlay
                        ? const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF2C003E), Color(0xFF19002E), Color(0xFF03001E)],
                          )
                        : const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFFFF0F6), Color(0xFFFBE4FF), Color(0xFFE8F0FE), Color(0xFFFFF5F5)],
                          ))
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFFFFFFF), Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
                      ),
              ),
            ),
            if (isLgbtMode)
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final value = _controller.value;
                  final size = MediaQuery.of(context).size;
                  return Stack(
                    children: _lgbtStickers.map((s) {
                      final currentX = ((s.x + s.speedX * value * 3) % 1.0) * size.width;
                      final currentY = ((s.y + s.speedY * value * 3) % 1.0) * size.height;
                      final bobbing = math.sin(value * 2 * math.pi + s.x * 10) * 8;

                      return Positioned(
                        left: currentX,
                        top: currentY + bobbing,
                        child: Transform.rotate(
                          angle: s.rotation + math.sin(value * 2 * math.pi) * 0.1,
                          child: Transform.scale(
                            scale: s.scale,
                            child: Opacity(
                              opacity: widget.darkOverlay ? 0.35 : 0.22,
                              child: Text(
                                s.emoji,
                                style: const TextStyle(fontSize: 28),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            widget.child,
          ],
        );
      },
    );
  }
}

class _FloatingStickerData {
  final String emoji;
  final double x;
  final double y;
  final double speedX;
  final double speedY;
  final double scale;
  final double rotation;

  _FloatingStickerData({
    required this.emoji,
    required this.x,
    required this.y,
    required this.speedX,
    required this.speedY,
    required this.scale,
    required this.rotation,
  });
}

// ═══════════════════════════════════════════════════════════
// RAINBOW SHIMMER TEXT — Switches to Pure Black Text in Straight Mode
// ═══════════════════════════════════════════════════════════
class RainbowShimmerText extends StatefulWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign textAlign;

  const RainbowShimmerText({
    super.key,
    required this.text,
    this.fontSize = 28,
    this.fontWeight = FontWeight.w700,
    this.textAlign = TextAlign.start,
  });

  @override
  State<RainbowShimmerText> createState() => _RainbowShimmerTextState();
}

class _RainbowShimmerTextState extends State<RainbowShimmerText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        if (!isLgbtMode) {
          return Text(
            widget.text,
            textAlign: widget.textAlign,
            style: GoogleFonts.inter(
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
              color: Colors.black,
            ),
          );
        }

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return ShaderMask(
              shaderCallback: (bounds) {
                return SweepGradient(
                  center: Alignment.center,
                  startAngle: 0,
                  endAngle: math.pi * 2,
                  transform: GradientRotation(_controller.value * math.pi * 2),
                  colors: const [
                    AppColors.hotPink,
                    AppColors.electricPurple,
                    AppColors.cyanSparkle,
                    AppColors.limeGreen,
                    AppColors.neonGold,
                    AppColors.hotPink,
                  ],
                ).createShader(bounds);
              },
              child: Text(
                widget.text,
                textAlign: widget.textAlign,
                style: GoogleFonts.fredoka(
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// BONGGA GLASS CARD — Switches to Strict Pure White Card in Straight Mode
// ═══════════════════════════════════════════════════════════
class BonggaCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final bool hasRainbowGlow;

  const BonggaCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.hasRainbowGlow = true,
  });

  @override
  State<BonggaCard> createState() => _BonggaCardState();
}

class _BonggaCardState extends State<BonggaCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: widget.padding ?? const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(isLgbtMode ? 26 : 14),
                color: isLgbtMode ? null : Colors.white,
                gradient: isLgbtMode ? glassGradient : null,
                boxShadow: isLgbtMode
                    ? (widget.hasRainbowGlow ? AppShadow.lifted : AppShadow.soft)
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                border: Border.all(
                  color: isLgbtMode ? Colors.white.withOpacity(0.9) : const Color(0xFFE5E7EB),
                  width: isLgbtMode ? 2 : 1.5,
                ),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// INTERACTIVE STICKER BADGE — Switches to Flat Black/Grey Tag in Straight Mode
// ═══════════════════════════════════════════════════════════
class InteractiveSticker extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double rotateAngle;

  const InteractiveSticker({
    super.key,
    required this.text,
    this.backgroundColor = AppColors.hotPink,
    this.textColor = Colors.white,
    this.rotateAngle = -0.05,
  });

  @override
  State<InteractiveSticker> createState() => _InteractiveStickerState();
}

class _InteractiveStickerState extends State<InteractiveSticker> {
  double _scale = 1.0;

  void _pop() {
    FunAudioPlayer.playStickerPop();
    setState(() => _scale = 1.35);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) setState(() => _scale = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        final activeColor = isLgbtMode ? widget.backgroundColor : const Color(0xFFF3F4F6);
        final activeAngle = isLgbtMode ? widget.rotateAngle : 0.0;

        return GestureDetector(
          onTap: _pop,
          child: Transform.rotate(
            angle: activeAngle,
            child: AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 180),
              curve: Curves.elasticOut,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(isLgbtMode ? 20 : 8),
                  boxShadow: isLgbtMode
                      ? [
                          BoxShadow(
                            color: activeColor.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                  border: Border.all(
                    color: isLgbtMode ? Colors.white : const Color(0xFFD1D5DB),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.text,
                  style: isLgbtMode
                      ? GoogleFonts.fredoka(
                          color: widget.textColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        )
                      : GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// RAINBOW MARK (GBBT LOGO MARK) — Switches to Strict Black/White Bank Icon in Straight Mode
// ═══════════════════════════════════════════════════════════
class RainbowMark extends StatefulWidget {
  final double size;
  const RainbowMark({super.key, this.size = 80});

  @override
  State<RainbowMark> createState() => _RainbowMarkState();
}

class _RainbowMarkState extends State<RainbowMark> with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.size;
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        if (!isLgbtMode) {
          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Icon(Icons.account_balance_rounded, size: size * 0.5, color: Colors.black),
            ),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            RotationTransition(
              turns: _rotationController,
              child: Container(
                width: size * 1.25,
                height: size * 1.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [
                      AppColors.hotPink.withOpacity(0.6),
                      AppColors.cyanSparkle.withOpacity(0.6),
                      AppColors.neonGold.withOpacity(0.6),
                      AppColors.limeGreen.withOpacity(0.6),
                      AppColors.electricPurple.withOpacity(0.6),
                      AppColors.hotPink.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.35),
                color: Colors.white,
                boxShadow: AppShadow.neonGlow,
                border: Border.all(color: AppColors.neonGold, width: 3),
              ),
              child: Center(
                child: SizedBox(
                  width: size * 0.6,
                  height: size * 0.6,
                  child: CustomPaint(painter: _UnicornHornPainter()),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _UnicornHornPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final hornPath = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w * 0.7, h * 0.92)
      ..lineTo(w * 0.3, h * 0.92)
      ..close();

    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.hotPink,
        AppColors.neonGold,
        AppColors.cyanSparkle,
        AppColors.electricPurple,
      ],
    );
    final paint = Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(hornPath, paint);

    final stripePaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..strokeWidth = w * 0.05
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 1; i <= 3; i++) {
      final t = i / 4;
      canvas.drawLine(
        Offset(w * (0.5 - 0.18 * t), h * (0.92 * t)),
        Offset(w * (0.5 + 0.18 * t), h * (0.92 * t) - h * 0.06),
        stripePaint,
      );
    }

    final sparklePaint = Paint()..color = AppColors.neonGold;
    _drawSparkle(canvas, Offset(w * 0.84, h * 0.16), w * 0.12, sparklePaint);
    _drawSparkle(canvas, Offset(w * 0.12, h * 0.75), w * 0.08, sparklePaint);
  }

  void _drawSparkle(Canvas canvas, Offset center, double r, Paint paint) {
    final path = Path();
    path.moveTo(center.dx, center.dy - r);
    path.lineTo(center.dx + r * 0.28, center.dy - r * 0.28);
    path.lineTo(center.dx + r, center.dy);
    path.lineTo(center.dx + r * 0.28, center.dy + r * 0.28);
    path.lineTo(center.dx, center.dy + r);
    path.lineTo(center.dx - r * 0.28, center.dy + r * 0.28);
    path.lineTo(center.dx - r, center.dy);
    path.lineTo(center.dx - r * 0.28, center.dy - r * 0.28);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════
// FUN BADGE (Pill sticker style)
// ═══════════════════════════════════════════════════════════
class FunBadge extends StatelessWidget {
  final String text;
  const FunBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: isLgbtMode ? electricRainbowGradient : null,
            color: isLgbtMode ? null : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(30),
            boxShadow: isLgbtMode
                ? [
                    BoxShadow(
                      color: AppColors.hotPink.withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
            border: Border.all(color: isLgbtMode ? Colors.white : const Color(0xFFD1D5DB), width: 1.5),
          ),
          child: Text(
            text,
            style: isLgbtMode
                ? GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  )
                : GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// GRADIENT / FLAT MONOCHROME BUTTON
// ═══════════════════════════════════════════════════════════
class GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.94 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOutBack,
            child: Opacity(
              opacity: disabled && !widget.isLoading ? 0.5 : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isLgbtMode ? 20 : 12),
                  gradient: isLgbtMode ? electricRainbowGradient : null,
                  color: isLgbtMode ? null : Colors.black,
                  boxShadow: isLgbtMode
                      ? AppShadow.lifted
                      : [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                  border: Border.all(
                    color: isLgbtMode ? Colors.white.withOpacity(0.6) : Colors.black,
                    width: 1.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(isLgbtMode ? 20 : 12),
                    onTap: widget.isLoading ? null : widget.onPressed,
                    child: Center(
                      child: widget.isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (widget.icon != null) ...[
                                  Icon(widget.icon, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                ],
                                Text(
                                  widget.label,
                                  style: isLgbtMode
                                      ? GoogleFonts.fredoka(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        )
                                      : GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════
// OA ANIMATED EXPLOSIVE POPUP DIALOG HELPERS 🎉💥💖
// ═══════════════════════════════════════════════════════════

/// 1. OA CASH SUCCESS EXPLOSIVE POPUP 🎉💸💥
Future<void> showOaSuccessDialog(
  BuildContext context, {
  required String title,
  required String subtitle,
  required double amount,
  required String recipient,
  String? purpose,
  required double fee,
}) async {
  FunAudioPlayer.playPopupFanfare();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _OaDialogWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🎉', style: TextStyle(fontSize: 42)),
              SizedBox(width: 4),
              Text('💸', style: TextStyle(fontSize: 54)),
              SizedBox(width: 4),
              Text('🥳', style: TextStyle(fontSize: 42)),
            ],
          ),
          const SizedBox(height: 12),

          InteractiveSticker(
            text: fee == 0 ? '✨ ₱0 FEE WAIVED 🌈' : '⚡ ₱${fee.toStringAsFixed(2)} FEE',
            backgroundColor: fee == 0 ? AppColors.limeGreen : AppColors.neonGold,
            textColor: AppColors.ink,
            rotateAngle: -0.04,
          ),
          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.5,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: electricRainbowGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadow.soft,
            ),
            child: Column(
              children: [
                Text(
                  '₱${amount.toStringAsFixed(2)}',
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Recipient: $recipient',
                  style: GoogleFonts.fredoka(color: Colors.white.withOpacity(0.9), fontSize: 13),
                ),
                if (purpose != null && purpose.isNotEmpty)
                  Text(
                    'Purpose: $purpose',
                    style: GoogleFonts.inter(color: Colors.white.withOpacity(0.85), fontSize: 12),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          GradientButton(
            label: 'SLAY! 💅',
            icon: Icons.check_circle_rounded,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}

/// 2. OA LIKE MATCH BUZZING HEART POPUP 💘💓🔥
Future<void> showOaLikeDialog(
  BuildContext context, {
  required String name,
}) async {
  FunAudioPlayer.playLoveMatchSound();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _OaDialogWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('💓', style: TextStyle(fontSize: 40)),
              SizedBox(width: 6),
              Text('💘', style: TextStyle(fontSize: 60)),
              SizedBox(width: 6),
              Text('💖', style: TextStyle(fontSize: 40)),
            ],
          ),
          const SizedBox(height: 12),

          const InteractiveSticker(
            text: '🔥 100% FINANCE MATCH',
            backgroundColor: AppColors.hotPink,
            rotateAngle: 0.05,
          ),
          const SizedBox(height: 14),

          Text(
            "IT'S A MATCH QUEEN! 💘",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.hotPink,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            "You and $name are financially & spiritually compatible! Sparkles & interest rates are flying! ✨💸",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.ink,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),

          GradientButton(
            label: 'CHAT SOON BESTIE 💬',
            icon: Icons.favorite_rounded,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}

/// 3. OA PASS REJECTION BYE POPUP 💔💅
Future<void> showOaPassDialog(
  BuildContext context, {
  required String name,
}) async {
  FunAudioPlayer.playPassSound();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _OaDialogWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💔', style: TextStyle(fontSize: 54)),
          const SizedBox(height: 12),

          const InteractiveSticker(
            text: '💅 NEXT FABULOUS SINGLE',
            backgroundColor: AppColors.electricPurple,
            rotateAngle: -0.04,
          ),
          const SizedBox(height: 14),

          Text(
            "BYE FELICIA! 💅❌",
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),

          Text(
            "Passed on $name. Onto someone with bigger savings & better vibes! 💸🚀",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.inkMuted,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.hotPink, width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              child: Text(
                'KEEP SWIPING 🚀',
                style: GoogleFonts.fredoka(color: AppColors.hotPink, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

/// 4. OA VIBE SCAN EXPLOSION POPUP 🔮🎉💥
Future<void> showOaVibeDialog(
  BuildContext context, {
  required int score,
  required String result,
}) async {
  FunAudioPlayer.playPopupFanfare();
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (context) => _OaDialogWrapper(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('🎉', style: TextStyle(fontSize: 40)),
              SizedBox(width: 4),
              Text('👑', style: TextStyle(fontSize: 56)),
              SizedBox(width: 4),
              Text('✨', style: TextStyle(fontSize: 40)),
            ],
          ),
          const SizedBox(height: 12),

          const InteractiveSticker(
            text: '💥 VIBE SCAN COMPLETE',
            backgroundColor: AppColors.neonGold,
            textColor: AppColors.ink,
            rotateAngle: 0.04,
          ),
          const SizedBox(height: 14),

          Text(
            '$score%',
            style: GoogleFonts.fredoka(
              fontSize: 52,
              fontWeight: FontWeight.w700,
              color: AppColors.hotPink,
            ),
          ),
          Text(
            'VIBE SCORE',
            style: GoogleFonts.fredoka(
              color: AppColors.inkMuted,
              letterSpacing: 2,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: electricRainbowGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadow.soft,
            ),
            child: Text(
              result,
              textAlign: TextAlign.center,
              style: GoogleFonts.fredoka(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 24),

          GradientButton(
            label: 'SLAY AGAIN 💅',
            icon: Icons.auto_awesome_rounded,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}

// ANIMATED EXPLOSIVE PARTY POPPER CONFETTI OVERLAY 🥳🎉💥
class PartyPopperOverlay extends StatefulWidget {
  final Widget child;
  const PartyPopperOverlay({super.key, required this.child});

  @override
  State<PartyPopperOverlay> createState() => _PartyPopperOverlayState();
}

class _PartyPopperOverlayState extends State<PartyPopperOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_ConfettiParticle> _particles = [];
  final math.Random _rng = math.Random();

  static const List<Color> _particleColors = [
    AppColors.hotPink,
    AppColors.electricPurple,
    AppColors.cyanSparkle,
    AppColors.limeGreen,
    AppColors.neonGold,
    AppColors.magenta,
    Colors.orange,
    Colors.amber,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    for (int i = 0; i < 50; i++) {
      final angle = -math.pi * 0.95 + _rng.nextDouble() * (math.pi * 0.9);
      final speed = 150.0 + _rng.nextDouble() * 350.0;
      _particles.add(_ConfettiParticle(
        color: _particleColors[i % _particleColors.length],
        vx: math.cos(angle) * speed,
        vy: math.sin(angle) * speed,
        size: 7.0 + _rng.nextDouble() * 9.0,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 14.0,
        isCircle: i % 2 == 0,
      ));
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          foregroundPainter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class _ConfettiParticle {
  final Color color;
  final double vx;
  final double vy;
  final double size;
  final double rotationSpeed;
  final bool isCircle;

  _ConfettiParticle({
    required this.color,
    required this.vx,
    required this.vy,
    required this.size,
    required this.rotationSpeed,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_ConfettiParticle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1.0) return;

    final originX = size.width / 2;
    final originY = size.height * 0.15;

    final gravity = 500.0 * progress * progress;
    final opacity = (1.0 - progress * 1.05).clamp(0.0, 1.0);

    for (final p in particles) {
      final x = originX + p.vx * progress;
      final y = originY + p.vy * progress + gravity;
      final rot = p.rotationSpeed * progress;

      final paint = Paint()
        ..color = p.color.withOpacity(opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size * 1.5, height: p.size * 0.7),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}

// Dialog Animated Scale & Explosive Particle Wrapper
class _OaDialogWrapper extends StatefulWidget {
  final Widget child;
  const _OaDialogWrapper({required this.child});

  @override
  State<_OaDialogWrapper> createState() => _OaDialogWrapperState();
}

class _OaDialogWrapperState extends State<_OaDialogWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    FunAudioPlayer.playPopupFanfare();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _rotateAnim = Tween<double>(begin: -0.06, end: 0.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: Transform.rotate(
        angle: _rotateAnim.value,
        child: PartyPopperOverlay(
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -24,
                left: 10,
                child: Transform.rotate(angle: -0.2, child: const Text('✨', style: TextStyle(fontSize: 32))),
              ),
              Positioned(
                top: -30,
                right: 15,
                child: Transform.rotate(angle: 0.3, child: const Text('🎉', style: TextStyle(fontSize: 36))),
              ),
              Positioned(
                bottom: -20,
                right: 25,
                child: Transform.rotate(angle: -0.15, child: const Text('💸', style: TextStyle(fontSize: 32))),
              ),
              Positioned(
                bottom: -15,
                left: 20,
                child: Transform.rotate(angle: 0.25, child: const Text('👑', style: TextStyle(fontSize: 30))),
              ),

              Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                  side: const BorderSide(color: AppColors.hotPink, width: 3),
                ),
                elevation: 20,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
