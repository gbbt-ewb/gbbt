import 'dart:convert';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';

// ═══════════════════════════════════════════════════════════
// FUN AUDIO SYNTHESIZER — Zero-dependency HTML5 WAV PCM Audio 🎵✨
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

  /// Interactive Sticker Click / Boing sound! 💅
  static void playStickerPop() {
    const rate = 16000;
    const numSamples = 2400; // 0.15s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      final freq = 300.0 + (t * 2800.0); // Bouncy pitch slide up!
      final amplitude = (1.0 - (t / 0.15)).clamp(0.0, 1.0);
      final val = (math.sin(t * freq * 2 * math.pi) * 127.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }

  /// OA Fanfare / Popup Explosion sound! 🎉
  static void playPopupFanfare() {
    const rate = 16000;
    const numSamples = 5600; // 0.35s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      double freq = 523.25; // C5
      if (t > 0.08) freq = 659.25; // E5
      if (t > 0.16) freq = 783.99; // G5
      if (t > 0.24) freq = 1046.50; // C6 major chord flourish
      final amplitude = (1.0 - (t / 0.35)).clamp(0.0, 1.0);
      final val = (math.sin(t * freq * 2 * math.pi) * 127.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }

  /// Love Match Buzz sound! 💖
  static void playLoveMatchSound() {
    const rate = 16000;
    const numSamples = 4800; // 0.3s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      double freq = 440.0;
      if (t > 0.07) freq = 554.37;
      if (t > 0.14) freq = 659.25;
      if (t > 0.21) freq = 880.0;
      final amplitude = (1.0 - (t / 0.3)).clamp(0.0, 1.0);
      final val = (math.sin(t * freq * 2 * math.pi) * 127.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }

  /// Sassy Rejection Pass sound! 💅💔
  static void playPassSound() {
    const rate = 16000;
    const numSamples = 4000; // 0.25s
    final samples = List<int>.generate(numSamples, (i) {
      final t = i / rate;
      final freq = 550.0 - (t * 1400.0).clamp(0.0, 450.0); // Pitch slide down
      final amplitude = (1.0 - (t / 0.25)).clamp(0.0, 1.0);
      final val = (math.sin(t * freq * 2 * math.pi) * 127.0 * amplitude).toInt();
      return (val + 128).clamp(0, 255);
    });
    _playPcmWav(samples, rate);
  }
}

// ═══════════════════════════════════════════════════════════
// ANIMATED "BONGGA" BACKGROUND — Floating & Drifting Stickers
// (✨ 💖 🦄 👑 🌈 💸 💅 💎 🌟) for that OA extra vibe!
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
  final List<_FloatingStickerData> _stickers = [];
  final math.Random _random = math.Random(42);

  static const List<String> _stickerEmojis = [
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
      _stickers.add(_FloatingStickerData(
        emoji: _stickerEmojis[i % _stickerEmojis.length],
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
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: widget.darkOverlay
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C003E),
                      Color(0xFF19002E),
                      Color(0xFF03001E),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFF0F6),
                      Color(0xFFFBE4FF),
                      Color(0xFFE8F0FE),
                      Color(0xFFFFF5F5),
                    ],
                  ),
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final value = _controller.value;
            final size = MediaQuery.of(context).size;
            return Stack(
              children: _stickers.map((s) {
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
// RAINBOW SHIMMER TEXT — Shimmering animated text gradient
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
  }
}

// ═══════════════════════════════════════════════════════════
// BONGGA GLASS CARD — Frosted Card with Glowing Border
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
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: Container(
          padding: widget.padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: glassGradient,
            boxShadow: widget.hasRainbowGlow ? AppShadow.lifted : AppShadow.soft,
            border: Border.all(
              color: Colors.white.withOpacity(0.9),
              width: 2,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// INTERACTIVE STICKER BADGE — Extra "OA" Philippine slang stickers!
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
    return GestureDetector(
      onTap: _pop,
      child: Transform.rotate(
        angle: widget.rotateAngle,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 180),
          curve: Curves.elasticOut,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.backgroundColor.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Text(
              widget.text,
              style: GoogleFonts.fredoka(
                color: widget.textColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// REVAMPED RAINBOW MARK (GBBT UNICORN LOGO MARK)
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: electricRainbowGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.hotPink.withOpacity(0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        text,
        style: GoogleFonts.fredoka(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// BOUNCY BONGGA GRADIENT BUTTON
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
          child: Container(
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: electricRainbowGradient,
              boxShadow: AppShadow.lifted,
              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
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
                              Icon(widget.icon, color: Colors.white, size: 22),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              widget.label,
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
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
          // Explosive Emoji Badge
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

          // Transaction Breakdown Card
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
          // Buzzing Hearts
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

// Dialog Animated Scale & Particle Wrapper
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
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Background Drifting Confetti Sparkles
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
    );
  }
}
