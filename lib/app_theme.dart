import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════
// DESIGN TOKENS — "OA & SUPER BONGGA" RAINBOW GLAMOUR vs MONOCHROME
// Vibrant, electric, glowing, extra, and unabashedly fabulous!
// ═══════════════════════════════════════════════════════════
class AppColors {
  // Base background & surfaces
  static const cream = Color(0xFFFFF0F6);
  static const darkPurple = Color(0xFF1E0836);
  static const ink = Color(0xFF280645);
  static const inkMuted = Color(0xFF8E71A5);
  static const surface = Colors.white;
  static const glassSurface = Color(0xCCFFFFFF);
  static const line = Color(0xFFFFD4EA);

  // Vibrant OA Neon Palette
  static const hotPink = Color(0xFFFF007F);
  static const magenta = Color(0xFFE0115F);
  static const electricPurple = Color(0xFF9D00FF);
  static const neonGold = Color(0xFFFFD700);
  static const sunnyYellow = Color(0xFFFFEA00);
  static const limeGreen = Color(0xFF39FF14);
  static const cyanSparkle = Color(0xFF00F5FF);
  static const skyBlue = Color(0xFF38B6FF);
  static const lavender = Color(0xFFD6A2E8);

  // Primary accent (Electrifying Hot Magenta)
  static const primary = Color(0xFFFF007F);
  static const secondary = Color(0xFF9D00FF);
  static const accentGold = Color(0xFFFFD700);
}

const rainbowGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    AppColors.hotPink,
    AppColors.magenta,
    AppColors.electricPurple,
    AppColors.cyanSparkle,
    AppColors.limeGreen,
    AppColors.neonGold,
  ],
);

const electricRainbowGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [
    Color(0xFFFF007F),
    Color(0xFFFF7B00),
    Color(0xFFFFD700),
    Color(0xFF00F5FF),
    Color(0xFF9D00FF),
  ],
);

const monoDarkGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFF1F2937),
    Color(0xFF111827),
  ],
);

const goldShimmerGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xFFFFD700),
    Color(0xFFFFF59D),
    Color(0xFFFFB300),
    Color(0xFFFFD700),
  ],
);

const glassGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Color(0xEEFFFFFF),
    Color(0xCCFBE4FF),
    Color(0xDDFFF0F6),
  ],
);

class AppShadow {
  static List<BoxShadow> soft = [
    BoxShadow(
      color: AppColors.hotPink.withOpacity(0.12),
      blurRadius: 20,
      spreadRadius: 2,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> lifted = [
    BoxShadow(
      color: AppColors.hotPink.withOpacity(0.35),
      blurRadius: 28,
      spreadRadius: 4,
      offset: const Offset(0, 12),
    ),
    BoxShadow(
      color: AppColors.electricPurple.withOpacity(0.25),
      blurRadius: 18,
      offset: const Offset(0, 6),
    ),
  ];

  static List<BoxShadow> neonGlow = [
    BoxShadow(
      color: AppColors.hotPink.withOpacity(0.5),
      blurRadius: 30,
      spreadRadius: 6,
    ),
    BoxShadow(
      color: AppColors.cyanSparkle.withOpacity(0.4),
      blurRadius: 20,
      spreadRadius: 2,
    ),
  ];
}

TextTheme _buildTextTheme() {
  final base = GoogleFonts.interTextTheme();
  return base.copyWith(
    displaySmall: GoogleFonts.fredoka(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: AppColors.ink,
      letterSpacing: -0.5,
    ),
    headlineSmall: GoogleFonts.fredoka(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    titleMedium: GoogleFonts.fredoka(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14.5,
      color: AppColors.ink,
      height: 1.45,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12.5,
      color: AppColors.inkMuted,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.fredoka(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
  );
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: AppColors.primary,
    scaffoldBackgroundColor: AppColors.cream,
    textTheme: _buildTextTheme(),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.line, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.line, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: AppColors.hotPink, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 14),
    ),
  );
}
