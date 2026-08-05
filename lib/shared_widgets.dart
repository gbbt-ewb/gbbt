import 'package:flutter/material.dart';
import 'app_theme.dart';

// ═══════════════════════════════════════════════════════════
// ORIGINAL LOGO MARK — a unicorn horn + sparkle glyph, drawn
// with CustomPainter. This is an original design for this app,
// not borrowed from any existing brand.
// ═══════════════════════════════════════════════════════════
class RainbowMark extends StatelessWidget {
  final double size;
  const RainbowMark({super.key, this.size = 72});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.32),
        color: Colors.white,
        boxShadow: AppShadow.lifted,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.56,
          height: size * 0.56,
          child: CustomPaint(painter: _UnicornHornPainter()),
        ),
      ),
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
      ..lineTo(w * 0.66, h * 0.9)
      ..lineTo(w * 0.34, h * 0.9)
      ..close();

    const gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [AppColors.pink, AppColors.yellow, AppColors.sky, AppColors.lavender],
    );
    final paint = Paint()..shader = gradient.createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(hornPath, paint);

    final stripePaint = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = w * 0.045
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    for (int i = 1; i <= 3; i++) {
      final t = i / 4;
      canvas.drawLine(
        Offset(w * (0.5 - 0.16 * t), h * (0.9 * t)),
        Offset(w * (0.5 + 0.16 * t), h * (0.9 * t) - h * 0.05),
        stripePaint,
      );
    }

    final sparklePaint = Paint()..color = AppColors.primary;
    _drawSparkle(canvas, Offset(w * 0.82, h * 0.18), w * 0.09, sparklePaint);
    _drawSparkle(canvas, Offset(w * 0.14, h * 0.72), w * 0.06, sparklePaint);
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

class FunBadge extends StatelessWidget {
  final String text;
  const FunBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.22), borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  const GradientButton({super.key, required this.label, required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final disabled = onPressed == null;
    return Opacity(
      opacity: disabled && !isLoading ? 0.5 : 1,
      child: Container(
        height: 56,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: rainbowGradient),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isLoading ? null : onPressed,
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                    )
                  : Text(label, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ),
    );
  }
}
