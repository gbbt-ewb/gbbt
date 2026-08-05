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
    return Scaffold(
      body: BonggaBackground(
        child: SafeArea(
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 700),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.topRight,
                    child: AppModeToggleSwitch(),
                  ),
                  const Spacer(flex: 1),
                  const FunBadge(text: '👑 100% FICTIONAL & EXTRA BONGGA 💅'),
                  const SizedBox(height: 20),
                  
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InteractiveSticker(text: '✨ SLAY!', rotateAngle: -0.1),
                      SizedBox(width: 8),
                      InteractiveSticker(
                        text: '💅 PAK!',
                        backgroundColor: AppColors.electricPurple,
                        rotateAngle: 0.08,
                      ),
                      SizedBox(width: 8),
                      InteractiveSticker(
                        text: '💸 KACHING',
                        backgroundColor: AppColors.neonGold,
                        textColor: AppColors.ink,
                        rotateAngle: -0.05,
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
                    style: GoogleFonts.fredoka(
                      color: AppColors.electricPurple,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Text(
                      "Banking so fabulous, extra & over-the-top, it's illegal to be this stylish. 🌈🦄💖",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: AppColors.ink,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        height: 1.45,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),

                  GradientButton(
                    label: 'Sign In Bestie 💅',
                    icon: Icons.login_rounded,
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    ),
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CreateAccountScreen()),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.85),
                        foregroundColor: AppColors.hotPink,
                        side: const BorderSide(color: AppColors.hotPink, width: 2.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.person_add_rounded, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'Create Account ✨',
                            style: GoogleFonts.fredoka(fontSize: 17, fontWeight: FontWeight.w600),
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
  }
}
