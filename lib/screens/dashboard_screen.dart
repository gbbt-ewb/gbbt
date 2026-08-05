import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'welcome_screen.dart';
import 'transfer_screen.dart';
import 'chatbot_screen.dart';
import 'dating_screen.dart';
import 'transfer_screen.dart';
import 'vibe_check_screen.dart';
import 'welcome_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel user;

  const DashboardScreen({
    super.key,
    required this.user,
  });

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  bool _balanceVisible = true;

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning, queen';
    if (hour < 18) return 'Good afternoon, iconic';
    return 'Good evening, bestie';
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      body: BonggaBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            children: [
              // Top Bar Header
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: electricRainbowGradient,
                      shape: BoxShape.circle,
                      boxShadow: AppShadow.lifted,
                      border: Border.all(color: Colors.white, width: 2.5),
                    ),
                    child: Center(
                      child: Text(
                        user.initials,
                        style: GoogleFonts.fredoka(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_greeting ✨',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.inkMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          user.firstName,
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InteractiveSticker(
                    text: '👑 VIP',
                    backgroundColor: AppColors.neonGold,
                    textColor: AppColors.ink,
                    rotateAngle: 0.05,
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.hotPink,
                      elevation: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // GBBT Holographic VIP Balance Card
              BonggaCard(
                padding: EdgeInsets.zero,
                hasRainbowGlow: true,
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF2B0045),
                        Color(0xFF800080),
                        Color(0xFFFF007F),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Text('💳', style: TextStyle(fontSize: 20)),
                              const SizedBox(width: 8),
                              Text(
                                'GBBT DIAMOND VIP VAULT',
                                style: GoogleFonts.fredoka(
                                  color: AppColors.neonGold,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _balanceVisible ? 'Hide' : 'Reveal',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      Text(
                        'Available Balance',
                        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                      ),
                      const SizedBox(height: 6),

                      Text(
                        _balanceVisible ? '₱${user.savings.toStringAsFixed(2)}' : '₱ • • • • • • •',
                        style: GoogleFonts.fredoka(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withOpacity(0.4)),
                            ),
                            child: Text(
                              user.taxBracket,
                              style: GoogleFonts.fredoka(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '4269 •••• •••• 1337',
                            style: GoogleFonts.fredoka(
                              color: AppColors.cyanSparkle,
                              fontSize: 13,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Features Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const RainbowShimmerText(text: 'Fabulous Features ✨', fontSize: 22),
                  const InteractiveSticker(text: '💅 BONGGA', rotateAngle: -0.04),
                ],
              ),
              const SizedBox(height: 14),

              // Feature Cards Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 1.15,
                children: [
                  _FeatureCard(
                    icon: Icons.send_rounded,
                    label: 'Bank Transfer',
                    subtitle: 'Free for LGBTQIA+ 🌈',
                    badgeText: '⚡ FREE',
                    accentColor: AppColors.hotPink,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => TransferScreen(user: user)),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chatbot',
                    subtitle: 'Ask GBBT anything 🤖',
                    badgeText: '🤖 SASS',
                    accentColor: AppColors.electricPurple,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ChatbotScreen()),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.favorite_rounded,
                    label: 'Money Match',
                    subtitle: 'Date by tax bracket 💖',
                    badgeText: '🔥 HOT',
                    accentColor: AppColors.magenta,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DatingScreen(user: user)),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.auto_awesome_rounded,
                    label: 'Vibe Check',
                    subtitle: 'Certified fabulous? ✨',
                    badgeText: '✨ 100%',
                    accentColor: AppColors.cyanSparkle,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const VibeCheckScreen()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String amount;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor:
            AppColors.lavender.withOpacity(.25),
        child: Icon(
          icon,
          color: AppColors.primary,
        ),
      ),
      title: Text(title),
      trailing: Text(
        amount,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String badgeText;
  final Color accentColor;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.badgeText,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BonggaCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accentColor, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}