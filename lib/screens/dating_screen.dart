import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class DatingScreen extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onBack;

  const DatingScreen({
    super.key,
    required this.user,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final matches = mockDatingProfiles
        .where((p) => p.taxBracket == user.taxBracket)
        .toList();

    final others = mockDatingProfiles
        .where((p) => p.taxBracket != user.taxBracket)
        .toList();

    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return Scaffold(
          body: BonggaBackground(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          if (onBack != null) {
                            onBack!();
                          } else if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios_new, size: 20, color: isLgbtMode ? AppColors.ink : Colors.black),
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
                      gradient: isLgbtMode ? electricRainbowGradient : monoDarkGradient,
                      borderRadius: BorderRadius.circular(isLgbtMode ? 24 : 14),
                      boxShadow: isLgbtMode ? AppShadow.lifted : null,
                    ),
                    child: Column(
                      children: [
                        const Text("💖", style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 8),
                        Text(
                          "Money Match ✨",
                          style: isLgbtMode
                              ? GoogleFonts.fredoka(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                )
                              : GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isLgbtMode
                              ? "Matched by tax bracket and savings because finance is sexy. 💅"
                              : "Match candidates based on tax bracket and savings alignment.",
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
                          "Your Matches (${user.taxBracket})",
                          style: isLgbtMode
                              ? GoogleFonts.fredoka(color: AppColors.ink, fontSize: 17, fontWeight: FontWeight.w600)
                              : GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        InteractiveSticker(
                          text: isLgbtMode ? '🔥 95% MATCH' : '95% MATCH',
                          rotateAngle: isLgbtMode ? 0.04 : 0.0,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...matches.map((profile) => _ProfileCard(profile: profile, isMatch: true, isLgbtMode: isLgbtMode)),
                    const SizedBox(height: 24),
                  ],

                  Text(
                    isLgbtMode ? "Other Fabulous Singles ✨" : "Other Profiles",
                    style: isLgbtMode
                        ? GoogleFonts.fredoka(color: AppColors.ink, fontSize: 18, fontWeight: FontWeight.w600)
                        : GoogleFonts.inter(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  ...others.map((profile) => _ProfileCard(profile: profile, isMatch: false, isLgbtMode: isLgbtMode)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final DatingProfile profile;
  final bool isMatch;
  final bool isLgbtMode;

  const _ProfileCard({
    required this.profile,
    required this.isMatch,
    required this.isLgbtMode,
  });

  int get compatibility => isMatch ? 95 : 68;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isLgbtMode ? 26 : 16),
        boxShadow: isLgbtMode
            ? (isMatch ? AppShadow.lifted : AppShadow.soft)
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(
          color: isLgbtMode
              ? (isMatch ? AppColors.hotPink : AppColors.line)
              : const Color(0xFFE2E8F0),
          width: isLgbtMode ? (isMatch ? 2.5 : 1.5) : 1.0,
        ),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(isLgbtMode ? 24 : 14),
                  ),
                  image: DecorationImage(
                    image: AssetImage(profile.coverPhoto),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: -36,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 38,
                    backgroundImage: AssetImage(
                      profile.photo,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
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
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              )
                            : GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                      ),
                    ),
                    if (isMatch)
                      InteractiveSticker(
                        text: isLgbtMode ? '💘 MATCH' : 'MATCH',
                        backgroundColor: isLgbtMode ? AppColors.hotPink : const Color(0xFFF1F5F9),
                        rotateAngle: isLgbtMode ? -0.04 : 0.0,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  profile.bio,
                  style: GoogleFonts.inter(
                    color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(profile.taxBracket, color: isLgbtMode ? AppColors.electricPurple : Colors.black),
                    _chip("₱${profile.savings.toStringAsFixed(0)} Saved 💸", color: isLgbtMode ? AppColors.hotPink : Colors.black),
                    if (profile.interests.isNotEmpty)
                      ...profile.interests.map((interest) => _chip(interest, color: isLgbtMode ? AppColors.skyBlue : Colors.black))
                    else ...[
                      _chip("Coffee ☕", color: isLgbtMode ? AppColors.skyBlue : Colors.black),
                      _chip("Travel ✈️", color: isLgbtMode ? AppColors.limeGreen : Colors.black),
                    ],
                  ],
                ),
                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Finance Compatibility",
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(fontSize: 14, color: AppColors.ink)
                          : GoogleFonts.inter(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "$compatibility%",
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: isMatch ? AppColors.hotPink : AppColors.electricPurple,
                            )
                          : GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black,
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
                    backgroundColor: isLgbtMode ? Colors.grey.shade200 : const Color(0xFFE5E7EB),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isLgbtMode
                          ? (isMatch ? AppColors.hotPink : AppColors.electricPurple)
                          : Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        label: Text(
                          isLgbtMode ? "Pass 💅" : "Pass",
                          style: isLgbtMode
                              ? GoogleFonts.fredoka(fontWeight: FontWeight.w600)
                              : GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          foregroundColor: isLgbtMode ? AppColors.inkMuted : Colors.black,
                          side: BorderSide(color: isLgbtMode ? AppColors.line : const Color(0xFFCBD5E1), width: 1.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isLgbtMode ? 16 : 8)),
                        ),
                        onPressed: () {
                          // Trigger OA Pass Rejection Popup!
                          showOaPassDialog(context, name: profile.name);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.favorite_rounded, size: 20),
                        label: Text(
                          isLgbtMode ? "Like 💖" : "Like",
                          style: isLgbtMode
                              ? GoogleFonts.fredoka(fontWeight: FontWeight.w700)
                              : GoogleFonts.inter(fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: isLgbtMode ? AppColors.hotPink : Colors.black,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(isLgbtMode ? 16 : 8)),
                        ),
                        onPressed: () {
                          // Trigger OA Like Heart Buzzing Match Popup!
                          showOaLikeDialog(context, name: profile.name);
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
        color: isLgbtMode ? color.withOpacity(0.12) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(isLgbtMode ? 20 : 6),
        border: Border.all(color: isLgbtMode ? color.withOpacity(0.3) : const Color(0xFFCBD5E1)),
      ),
      child: Text(
        text,
        style: isLgbtMode
            ? GoogleFonts.fredoka(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              )
            : GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
      ),
    );
  }
}