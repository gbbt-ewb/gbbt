import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════
// DESIGN TOKENS — a soft pastel rainbow, used deliberately
// (hero surfaces + one signature logo) rather than splashed
// everywhere, so it reads as intentional rather than chaotic.
// ═══════════════════════════════════════════════════════════
class AppColors {
  static const cream = Color(0xFFFFFBF7);
  static const ink = Color(0xFF2B2440);
  static const inkMuted = Color(0xFF948CA6);
  static const surface = Colors.white;
  static const line = Color(0xFFF1ECF7);

  static const pink = Color(0xFFFFB3C6);
  static const peach = Color(0xFFFFD8A8);
  static const yellow = Color(0xFFFFF0A3);
  static const mint = Color(0xFFB7F0D4);
  static const sky = Color(0xFFA7DBE8);
  static const lavender = Color(0xFFC9B6E8);

  // Primary accent (orchid-purple) used for buttons/icons/links —
  // keeps the UI legible where a full rainbow gradient would be too busy.
  static const primary = Color(0xFFB16CE0);
}

const rainbowGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    AppColors.pink,
    AppColors.peach,
    AppColors.yellow,
    AppColors.mint,
    AppColors.sky,
    AppColors.lavender,
  ],
);

class AppShadow {
  static List<BoxShadow> soft = [
    BoxShadow(color: AppColors.ink.withOpacity(0.06), blurRadius: 24, offset: const Offset(0, 10)),
  ];
  static List<BoxShadow> lifted = [
    BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 28, offset: const Offset(0, 14)),
  ];
}

TextTheme _buildTextTheme() {
  final base = GoogleFonts.interTextTheme();
  return base.copyWith(
    displaySmall: GoogleFonts.baloo2(fontSize: 34, fontWeight: FontWeight.w800, color: AppColors.ink),
    headlineSmall: GoogleFonts.baloo2(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink),
    titleMedium: GoogleFonts.baloo2(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.ink),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: AppColors.ink, height: 1.4),
    bodySmall: GoogleFonts.inter(fontSize: 12.5, color: AppColors.inkMuted, height: 1.4),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
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
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent)),
      labelStyle: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 14),
    ),
  );
}
