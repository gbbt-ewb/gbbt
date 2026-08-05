import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'aura_exchange_screen.dart';
import 'broke_finder_screen.dart';
import 'chatbot_screen.dart';
import 'dating_screen.dart';
import 'transfer_screen.dart';
import 'vibe_check_screen.dart';
import 'welcome_screen.dart';

class DashboardScreen extends StatefulWidget {
  final UserModel user;

  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            children: [
              // 1. HEADER
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
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
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$_greeting ✨',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.inkMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          user.firstName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const InteractiveSticker(
                    text: '👑 VIP',
                    backgroundColor: AppColors.neonGold,
                    textColor: AppColors.ink,
                    rotateAngle: 0.04,
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: AppColors.ink,
                          content: Text(
                            '🔔 No new alerts! You are 100% fabulous! ✨',
                            style: GoogleFonts.fredoka(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.electricPurple,
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
                    onPressed: _logout,
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.hotPink,
                      elevation: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 2. HOLOGRAPHIC VIP BALANCE CARD
              BonggaCard(
                padding: EdgeInsets.zero,
                hasRainbowGlow: true,
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('💳', style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    'GBBT DIAMOND VIP VAULT',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.fredoka(
                                      color: AppColors.neonGold,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => setState(
                              () => _balanceVisible = !_balanceVisible,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _balanceVisible
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _balanceVisible ? 'Hide' : 'Reveal',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Text(
                        'Available Balance',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          _balanceVisible
                              ? '₱${user.savings.toStringAsFixed(2)}'
                              : '₱ • • • • • • •',
                          style: GoogleFonts.fredoka(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.4),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '🌟 ',
                                    style: TextStyle(fontSize: 11),
                                  ),
                                  Flexible(
                                    child: Text(
                                      'Gold Member · ${user.taxBracket}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.fredoka(
                                        color: Colors.white,
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '4269 •••• •••• 1337',
                            style: GoogleFonts.fredoka(
                              color: AppColors.cyanSparkle,
                              fontSize: 12,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 3. FINANCIAL HEALTH SECTION
              BonggaCard(
                hasRainbowGlow: false,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Financial Health 💪",
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.ink,
                          ),
                        ),
                        Text(
                          user.savings > 100000 ? "92%" : "67%",
                          style: GoogleFonts.fredoka(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.hotPink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: user.savings > 100000 ? 0.92 : 0.67,
                        minHeight: 12,
                        backgroundColor: AppColors.line,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.hotPink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    Text(
                      user.savings > 100000
                          ? "Excellent savings habits! VIP Status Secured 🎉✨"
                          : "Keep building your savings, bestie! Almost to Elite Status 💪💖",
                      style: GoogleFonts.inter(
                        color: AppColors.inkMuted,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. QUICK ACTIONS
              Text(
                "Quick Actions",
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _QuickAction(
                    icon: Icons.send_rounded,
                    title: 'Transfer',
                    color: AppColors.hotPink,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TransferScreen(user: user),
                      ),
                    ),
                  ),
                  _QuickAction(
                    icon: Icons.savings_rounded,
                    title: 'Save',
                    color: AppColors.limeGreen,
                    onTap: () {
                      showOaSuccessDialog(
                        context,
                        title: 'SAVED TO VAULT! 💰✨',
                        subtitle: '₱500.00 added to your GBBT Piggy Bank! Money moves only! 💅',
                        amount: 500.0,
                        recipient: 'GBBT Vault',
                        purpose: 'Piggy Bank Savings',
                        fee: 0.0,
                      );
                    },
                  ),
                  _QuickAction(
                    icon: Icons.bar_chart_rounded,
                    title: 'Invest',
                    color: AppColors.electricPurple,
                    onTap: () {
                      showOaSuccessDialog(
                        context,
                        title: 'INVESTMENT BOOM! 📈🔥',
                        subtitle: 'GBBT Rainbow Index is soaring +15.4%! Stonks are looking fabulous! 🚀',
                        amount: 1000.0,
                        recipient: 'GBBT Rainbow Fund',
                        purpose: 'Portfolio Growth',
                        fee: 0.0,
                      );
                    },
                  ),
                  _QuickAction(
                    icon: Icons.receipt_long_rounded,
                    title: 'Bills',
                    color: AppColors.neonGold,
                    onTap: () {
                      showOaSuccessDialog(
                        context,
                        title: 'BILLS PAID IN FULL! 🧾💅',
                        subtitle: 'Zero debt, 100% Sass! You are an unbothered queen! 👑',
                        amount: 1250.0,
                        recipient: 'Glamour Utilities',
                        purpose: 'Bills Settlement',
                        fee: 0.0,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 5. FEATURES GRID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: RainbowShimmerText(
                      text: 'Fabulous Features ✨',
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const InteractiveSticker(
                    text: '💅 BONGGA',
                    rotateAngle: -0.04,
                  ),
                ],
              ),
              const SizedBox(height: 14),

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
                      MaterialPageRoute(
                        builder: (_) => TransferScreen(user: user),
                      ),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chatbot',
                    subtitle: 'Ask GBBT anything 🤖',
                    badgeText: '🤖 SASS',
                    accentColor: AppColors.electricPurple,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ChatbotScreen(),
                      ),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.favorite_rounded,
                    label: 'Money Match',
                    subtitle: 'Date by tax bracket 💖',
                    badgeText: '🔥 HOT',
                    accentColor: AppColors.magenta,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => DatingScreen(user: user),
                      ),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.auto_awesome_rounded,
                    label: 'Vibe Check',
                    subtitle: 'Certified fabulous? ✨',
                    badgeText: '✨ 100%',
                    accentColor: AppColors.cyanSparkle,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const VibeCheckScreen(),
                      ),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.map_rounded,
                    label: 'BrokeFinder',
                    subtitle: 'City wealth map 🗺️',
                    badgeText: '📊 CITY AVG',
                    accentColor: AppColors.limeGreen,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const BrokeFinderScreen(),
                      ),
                    ),
                  ),
                  _FeatureCard(
                    icon: Icons.show_chart_rounded,
                    label: 'Aura Exchange',
                    subtitle: 'Invest in vibes 📈',
                    badgeText: '🚀 TRENDING',
                    accentColor: AppColors.neonGold,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AuraExchangeScreen(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 6. RECENT ACTIVITY
              Text(
                'Recent Activity 📜',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),

              BonggaCard(
                hasRainbowGlow: false,
                padding: EdgeInsets.zero,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: const [
                      _ActivityTile(
                        icon: Icons.send_rounded,
                        title: 'Transfer to Jamie',
                        subtitle: 'Personal Transfer · Fee Waived 🌈',
                        amount: '- ₱2,500',
                        isNegative: true,
                      ),
                      Divider(height: 1, color: AppColors.line),
                      _ActivityTile(
                        icon: Icons.savings_rounded,
                        title: 'Savings Deposit',
                        subtitle: 'GBBT Starter Bonus 💸',
                        amount: '+ ₱10,000',
                        isNegative: false,
                      ),
                      Divider(height: 1, color: AppColors.line),
                      _ActivityTile(
                        icon: Icons.favorite_rounded,
                        title: 'Money Match Premium',
                        subtitle: 'Tax Bracket Match Pass ✨',
                        amount: '- ₱99',
                        isNegative: true,
                      ),
                    ],
                  ),
                ),
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
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: color.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.fredoka(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;
  final bool isNegative;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: (isNegative ? AppColors.hotPink : AppColors.limeGreen)
              .withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isNegative ? AppColors.hotPink : AppColors.limeGreen,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.fredoka(fontSize: 14.5, fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.inkMuted),
      ),
      trailing: Text(
        amount,
        style: GoogleFonts.fredoka(
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: isNegative ? AppColors.ink : AppColors.limeGreen,
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
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accentColor, size: 22),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.fredoka(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }
}