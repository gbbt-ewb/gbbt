import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class DatingScreen extends StatelessWidget {
  final UserModel user;

  const DatingScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final matches = mockDatingProfiles
        .where((p) => p.taxBracket == user.taxBracket)
        .toList();

    final others = mockDatingProfiles
        .where((p) => p.taxBracket != user.taxBracket)
        .toList();

    return Scaffold(
      body: BonggaBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.ink),
                    style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                  ),
                  const SizedBox(width: 12),
                  const RainbowShimmerText(text: 'Money Match 💘', fontSize: 24),
                ],
              ),
              const SizedBox(height: 18),

              // Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: electricRainbowGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadow.lifted,
                ),
                child: Column(
                  children: [
                    const Text("💖", style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text(
                      "Money Match ✨",
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Matched by tax bracket and savings because finance is sexy. 💅",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (matches.isNotEmpty) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tax Bracket Matches (${user.taxBracket})",
                      style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const InteractiveSticker(text: '🔥 95% MATCH', rotateAngle: 0.04),
                  ],
                ),
                const SizedBox(height: 12),
                ...matches.map((profile) => _ProfileCard(profile: profile, isMatch: true)),
                const SizedBox(height: 24),
              ],

              Text(
                "Other Fabulous Singles ✨",
                style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...others.map((profile) => _ProfileCard(profile: profile, isMatch: false)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final DatingProfile profile;
  final bool isMatch;

  const _ProfileCard({
    required this.profile,
    required this.isMatch,
  });

  int get compatibility => isMatch ? 95 : 68;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(26),
        boxShadow: isMatch ? AppShadow.lifted : AppShadow.soft,
        border: Border.all(
          color: isMatch ? AppColors.hotPink : AppColors.line,
          width: isMatch ? 2.5 : 1.5,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: isMatch ? electricRainbowGradient : rainbowGradient,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: AppColors.cream,
                  child: Text(
                    profile.name[0],
                    style: GoogleFonts.fredoka(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.hotPink,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${profile.name}, ${profile.age}",
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    if (isMatch)
                      const InteractiveSticker(
                        text: '💘 MATCH',
                        backgroundColor: AppColors.hotPink,
                        rotateAngle: -0.04,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  profile.bio,
                  style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 13.5, height: 1.4),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(profile.taxBracket, color: AppColors.electricPurple),
                    _chip("₱${profile.savings.toStringAsFixed(0)} Saved 💸", color: AppColors.hotPink),
                    _chip("Coffee ☕", color: AppColors.skyBlue),
                    _chip("Travel ✈️", color: AppColors.limeGreen),
                  ],
                ),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Finance Compatibility", style: GoogleFonts.fredoka(fontSize: 14, color: AppColors.ink)),
                    Text(
                      "$compatibility%",
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isMatch ? AppColors.hotPink : AppColors.electricPurple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: compatibility / 100,
                    minHeight: 12,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isMatch ? AppColors.hotPink : AppColors.electricPurple,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        label: Text("Pass 💅", style: GoogleFonts.fredoka(fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: AppColors.inkMuted,
                          side: const BorderSide(color: AppColors.line, width: 2),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text("Passed on ${profile.name}! Onto bigger fish 🐟"),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.favorite_rounded, size: 20),
                        label: Text("Like 💖", style: GoogleFonts.fredoka(fontWeight: FontWeight.w700)),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: AppColors.hotPink,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: AppColors.ink,
                              content: Text("You liked ${profile.name}! It's a match, queen! ❤️✨"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, {Color color = AppColors.electricPurple}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: GoogleFonts.fredoka(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}