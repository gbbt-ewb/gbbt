import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../shared_widgets.dart';
import 'login_screen.dart';
import 'create_account_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return Scaffold(
          body: BonggaBackground(
            child: SafeArea(
              child: AnimatedOpacity(
                opacity: _visible ? 1 : 0,
                duration: const Duration(milliseconds: 700),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topRight,
                        child: AppModeToggleSwitch(),
                      ),
                      const Spacer(flex: 1),
                      FunBadge(
                        text: isLgbtMode
                            ? '👑 MAKE YOUR BANKING EXTRA BONGGA 💅'
                            : 'GBBT BANKING 🏦',
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InteractiveSticker(
                            text: isLgbtMode ? '✨ SLAY!' : 'SECURE',
                            rotateAngle: isLgbtMode ? -0.1 : 0.0,
                          ),
                          const SizedBox(width: 8),
                          InteractiveSticker(
                            text: isLgbtMode ? '💅 PAK!' : 'FINANCE',
                            backgroundColor: isLgbtMode
                                ? AppColors.electricPurple
                                : const Color(0xFFF1F5F9),
                            textColor: isLgbtMode ? Colors.white : Colors.black,
                            rotateAngle: isLgbtMode ? 0.08 : 0.0,
                          ),
                          const SizedBox(width: 8),
                          InteractiveSticker(
                            text: isLgbtMode ? '💸 KACHING' : 'FAST',
                            backgroundColor: isLgbtMode
                                ? AppColors.neonGold
                                : const Color(0xFFF1F5F9),
                            textColor: Colors.black,
                            rotateAngle: isLgbtMode ? -0.05 : 0.0,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const RainbowMark(size: 100),
                      const SizedBox(height: 28),
                      const RainbowShimmerText(
                        text: 'GBBT Bank',
                        fontSize: 46,
                        fontWeight: FontWeight.w800,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Girl Bakla Bakla Tombits Bank',
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(
                                color: AppColors.electricPurple,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              )
                            : GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.circular(isLgbtMode ? 20 : 12),
                          border: Border.all(
                            color: isLgbtMode
                                ? Colors.white
                                : const Color(0xFFCBD5E1),
                            width: isLgbtMode ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          isLgbtMode
                              ? "Saving Cash with Sass 🌈🦄💖"
                              : "Saving Cash with Class",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: isLgbtMode ? AppColors.ink : Colors.black,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                            height: 1.45,
                          ),
                        ),
                      ),
                      const Spacer(flex: 2),
                      GradientButton(
                        label: isLgbtMode ? 'Sign In Bestie 💅' : 'Sign In',
                        icon: Icons.login_rounded,
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        ),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const CreateAccountScreen()),
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor:
                                isLgbtMode ? AppColors.hotPink : Colors.black,
                            side: BorderSide(
                              color:
                                  isLgbtMode ? AppColors.hotPink : Colors.black,
                              width: isLgbtMode ? 2.5 : 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(isLgbtMode ? 20 : 12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person_add_rounded, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                isLgbtMode
                                    ? 'Create Account ✨'
                                    : 'Create Account',
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600)
                                    : GoogleFonts.inter(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
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
