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
  int _selectedIndex = 0;

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

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => ValueListenableBuilder<bool>(
          valueListenable: AppModeController.instance,
          builder: (context, isLgbtMode, _) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isLgbtMode ? 30 : 16),
                  border: Border.all(
                    color: isLgbtMode ? Colors.pinkAccent : const Color(0xFFCBD5E1),
                    width: isLgbtMode ? 4 : 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isLgbtMode
                          ? Colors.pink.withOpacity(.3)
                          : Colors.black.withOpacity(.08),
                      blurRadius: isLgbtMode ? 20 : 16,
                      spreadRadius: isLgbtMode ? 5 : 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLgbtMode ? '🌈✨👑' : '🏦',
                      style: TextStyle(fontSize: isLgbtMode ? 50 : 44),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'WELCOME BACK!',
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            )
                          : GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      isLgbtMode
                          ? 'Welcome back, ${widget.user.firstName}! Ready to slay? 💅'
                          : 'Welcome back, ${widget.user.firstName}.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: isLgbtMode ? AppColors.inkMuted : const Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        gradient: isLgbtMode
                            ? electricRainbowGradient
                            : const LinearGradient(
                                colors: [Color(0xFF111111), Color(0xFF222222)],
                              ),
                        borderRadius: BorderRadius.circular(isLgbtMode ? 24 : 12),
                      ),
                      child: Text(
                        isLgbtMode ? '✨ LET\'S GO ✨' : 'GBBT BANKING',
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )
                            : GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.2,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLgbtMode ? AppColors.hotPink : Colors.black,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(isLgbtMode ? 30 : 12),
                          ),
                        ),
                        child: Text(
                          isLgbtMode ? 'SLAY! 💅' : 'CONTINUE',
                          style: isLgbtMode
                              ? GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w600)
                              : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildHomeDashboard(bool isLgbtMode, UserModel user) {
    final darkColor = isLgbtMode ? null : const Color(0xFF111111);

    return BonggaBackground(
      child: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                // Mode Toggle Bar
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FunBadge(text: 'GBBT BANKING 🏦'),
                    AppModeToggleSwitch(),
                  ],
                ),
                const SizedBox(height: 14),

                // 1. HEADER
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: isLgbtMode ? electricRainbowGradient : null,
                        color: darkColor,
                        shape: BoxShape.circle,
                        boxShadow: isLgbtMode ? AppShadow.lifted : null,
                        border: Border.all(
                          color: isLgbtMode ? Colors.white : Colors.black,
                          width: 2,
                        ),
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
                            isLgbtMode ? '$_greeting ✨' : 'Good day,',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isLgbtMode
                                  ? AppColors.inkMuted
                                  : const Color(0xFF6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            user.fullName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: isLgbtMode
                                ? GoogleFonts.fredoka(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.ink,
                                  )
                                : GoogleFonts.inter(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    InteractiveSticker(
                      text: isLgbtMode ? '👑 VIP' : 'VIP',
                      backgroundColor:
                          isLgbtMode ? AppColors.neonGold : const Color(0xFFF3F4F6),
                      textColor: isLgbtMode ? AppColors.ink : Colors.black,
                      rotateAngle: 0.04,
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: isLgbtMode
                                ? AppColors.ink
                                : Colors.black,
                            content: Text(
                              '🔔 No new alerts! System clear.',
                              style: isLgbtMode
                                  ? GoogleFonts.fredoka()
                                  : GoogleFonts.inter(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_none_rounded, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: isLgbtMode
                            ? AppColors.electricPurple
                            : Colors.black,
                        elevation: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 38,
                        minHeight: 38,
                      ),
                      onPressed: _logout,
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: isLgbtMode
                            ? AppColors.hotPink
                            : Colors.black,
                        elevation: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // 2. BALANCE VAULT CARD
                BonggaCard(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        isLgbtMode ? 24 : 14,
                      ),
                      gradient: isLgbtMode
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF2C004D),
                                Color(0xFF5B007A),
                                Color(0xFF90008E),
                              ],
                            )
                          : const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF111111), Color(0xFF222222)],
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
                                  const Text(
                                    '💳',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      isLgbtMode
                                          ? 'GBBT DIAMOND VIP VAULT'
                                          : 'GBBT CHECKING ACCOUNT',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: isLgbtMode
                                          ? GoogleFonts.fredoka(
                                              color: AppColors.neonGold,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.5,
                                              letterSpacing: 0.8,
                                            )
                                          : GoogleFonts.inter(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                              letterSpacing: 0.5,
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    _balanceVisible
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                    () => _balanceVisible = !_balanceVisible,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isLgbtMode
                                        ? Colors.white.withOpacity(0.2)
                                        : Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    user.taxBracket,
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'TOTAL FABULOUS BALANCE',
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),

                        _balanceVisible
                            ? ShaderMask(
                                shaderCallback: (bounds) => (isLgbtMode
                                        ? const LinearGradient(
                                            colors: [
                                              Colors.white,
                                              AppColors.cyanSparkle,
                                              AppColors.hotPink,
                                            ],
                                          )
                                        : const LinearGradient(
                                            colors: [Colors.white, Colors.white],
                                          ))
                                    .createShader(bounds),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    '₱${user.savings.toStringAsFixed(2)}',
                                    style: isLgbtMode
                                        ? GoogleFonts.fredoka(
                                            fontSize: 34,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          )
                                        : GoogleFonts.inter(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              )
                            : Text(
                                '₱ ••••••••',
                                style: GoogleFonts.fredoka(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ACCOUNT HOLDER',
                                  style: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 9.5,
                                  ),
                                ),
                                Text(
                                  user.fullName.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'CARD NUMBER',
                                  style: GoogleFonts.inter(
                                    color: Colors.white54,
                                    fontSize: 9.5,
                                  ),
                                ),
                                Text(
                                  '4269 •••• •••• 1337',
                                  style: GoogleFonts.fredoka(
                                    color: isLgbtMode
                                        ? AppColors.cyanSparkle
                                        : Colors.white70,
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 3. FINANCIAL HEALTH PROGRESS BAR
                BonggaCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isLgbtMode ? 'Financial Health 💖' : 'Account Status',
                            style: isLgbtMode
                                ? GoogleFonts.fredoka(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.ink,
                                  )
                                : GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                          ),
                          Text(
                            user.savings > 100000
                                ? '92% (Slaying 🔥)'
                                : '67% (Solid 👌)',
                            style: isLgbtMode
                                ? GoogleFonts.fredoka(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.hotPink,
                                  )
                                : GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: user.savings > 100000 ? 0.92 : 0.67,
                          minHeight: 10,
                          backgroundColor:
                              isLgbtMode ? AppColors.line : const Color(0xFFE5E7EB),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isLgbtMode ? AppColors.hotPink : Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        isLgbtMode
                            ? "Excellent savings habits! Vault in high glamour standing ✨"
                            : "Keep building your savings.",
                        style: GoogleFonts.inter(
                          color: isLgbtMode
                              ? AppColors.inkMuted
                              : const Color(0xFF6B7280),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // 4. QUICK ACTIONS
                Text(
                  'Quick Actions',
                  style: isLgbtMode
                      ? GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        )
                      : GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _QuickAction(
                      icon: Icons.send_rounded,
                      title: 'Transfer',
                      color: isLgbtMode ? AppColors.hotPink : Colors.black,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                      },
                    ),
                    _QuickAction(
                      icon: Icons.savings_rounded,
                      title: 'Save',
                      color: isLgbtMode ? AppColors.limeGreen : Colors.black,
                      onTap: () {
                        showOaSuccessDialog(
                          context,
                          title: 'SAVED TO VAULT! 💰✨',
                          subtitle:
                              '₱500.00 added to your GBBT Piggy Bank! Money moves only! 💅',
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
                      color: isLgbtMode
                          ? AppColors.electricPurple
                          : Colors.black,
                      onTap: () {
                        setState(() {
                          _selectedIndex = 4;
                        });
                      },
                    ),
                    _QuickAction(
                      icon: Icons.receipt_long_rounded,
                      title: 'Bills',
                      color: isLgbtMode ? AppColors.neonGold : Colors.black,
                      onTap: () {
                        showOaSuccessDialog(
                          context,
                          title: 'BILLS PAID IN FULL! 🧾💅',
                          subtitle:
                              'Zero debt, 100% Sass! You are an unbothered queen! 👑',
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

                // 5. FEATURES GRID HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'GBBT Features',
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            )
                          : GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                    ),
                    InteractiveSticker(
                      text: isLgbtMode ? '💅 ICONIC' : 'ALL FEATURES',
                      rotateAngle: isLgbtMode ? -0.03 : 0.0,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 6. FEATURES GRID (RESPONSIVE COMPACT RECTANGLES)
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    final crossAxisCount = width > 550 ? 3 : 2;

                    final cards = [
                      _FeatureCard(
                        icon: Icons.send_rounded,
                        label: 'Bank Transfer',
                        subtitle: 'Free Instant Transfer ⚡',
                        badgeText: '⚡ FREE',
                        accentColor: isLgbtMode ? AppColors.hotPink : Colors.black,
                        onTap: () => setState(() => _selectedIndex = 1),
                        isLgbtMode: isLgbtMode,
                      ),
                      _FeatureCard(
                        icon: Icons.smart_toy_rounded,
                        label: 'Chatbot',
                        subtitle: 'AI Financial Assistant 🤖',
                        badgeText: '🤖 AI',
                        accentColor: isLgbtMode ? AppColors.electricPurple : Colors.black,
                        onTap: () => setState(() => _selectedIndex = 3),
                        isLgbtMode: isLgbtMode,
                      ),
                      _FeatureCard(
                        icon: Icons.favorite_rounded,
                        label: 'Money Match',
                        subtitle: 'Date by tax bracket 💖',
                        badgeText: '🔥 HOT',
                        accentColor: isLgbtMode ? AppColors.magenta : Colors.black,
                        onTap: () => setState(() => _selectedIndex = 2),
                        isLgbtMode: isLgbtMode,
                      ),
                      _FeatureCard(
                        icon: Icons.camera_front_rounded,
                        label: 'Vibe Check',
                        subtitle: 'Certified fabulous? ✨',
                        badgeText: '✨ 100%',
                        accentColor: isLgbtMode ? AppColors.cyanSparkle : Colors.black,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const VibeCheckScreen()),
                        ),
                        isLgbtMode: isLgbtMode,
                      ),
                      _FeatureCard(
                        icon: Icons.map_rounded,
                        label: 'BrokeFinder',
                        subtitle: 'City wealth map 🗺️',
                        badgeText: '📊 MAP',
                        accentColor: isLgbtMode ? AppColors.limeGreen : Colors.black,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const BrokeFinderScreen()),
                        ),
                        isLgbtMode: isLgbtMode,
                      ),
                      _FeatureCard(
                        icon: Icons.show_chart_rounded,
                        label: 'Aura Exchange',
                        subtitle: 'Invest in vibes 📈',
                        badgeText: '🚀 STOCKS',
                        accentColor: isLgbtMode ? AppColors.neonGold : Colors.black,
                        onTap: () => setState(() => _selectedIndex = 4),
                        isLgbtMode: isLgbtMode,
                      ),
                    ];

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 110,
                      ),
                      itemCount: cards.length,
                      itemBuilder: (context, index) => cards[index],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // 7. RECENT ACTIVITY
                Text(
                  'Recent Transactions',
                  style: isLgbtMode
                      ? GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        )
                      : GoogleFonts.inter(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                ),
                const SizedBox(height: 12),

                BonggaCard(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      _ActivityTile(
                        icon: Icons.shopping_bag_rounded,
                        title: 'Starbucks Venti Iced Latte',
                        subtitle: 'Food & Dining • Today',
                        amount: '- ₱295',
                        isNegative: true,
                        isLgbtMode: isLgbtMode,
                      ),
                      Divider(
                        height: 1,
                        color: isLgbtMode
                            ? AppColors.line
                            : const Color(0xFFE5E7EB),
                      ),
                      _ActivityTile(
                        icon: Icons.arrow_downward_rounded,
                        title: 'Received from Alex Santos',
                        subtitle: 'Transfer • Yesterday',
                        amount: '+ ₱2,500',
                        isNegative: false,
                        isLgbtMode: isLgbtMode,
                      ),
                      Divider(
                        height: 1,
                        color: isLgbtMode
                            ? AppColors.line
                            : const Color(0xFFE5E7EB),
                      ),
                      _ActivityTile(
                        icon: Icons.diamond_rounded,
                        title: 'Gucci Platform Heels',
                        subtitle: 'Glamour Spend • 2 days ago',
                        amount: '- ₱99',
                        isNegative: true,
                        isLgbtMode: isLgbtMode,
                      ),
                      Divider(
                        height: 1,
                        color: isLgbtMode
                            ? AppColors.line
                            : const Color(0xFFE5E7EB),
                      ),
                      _ActivityTile(
                        icon: Icons.savings_rounded,
                        title: 'Savings Deposit',
                        subtitle: 'Piggy Vault • 3 days ago',
                        amount: '+ ₱5,000',
                        isNegative: false,
                        isLgbtMode: isLgbtMode,
                      ),
                      Divider(
                        height: 1,
                        color: isLgbtMode
                            ? AppColors.line
                            : const Color(0xFFE5E7EB),
                      ),
                      _ActivityTile(
                        icon: Icons.favorite_rounded,
                        title: 'Money Match Premium',
                        subtitle: 'Dating Feature • 4 days ago',
                        amount: '- ₱199',
                        isNegative: true,
                        isLgbtMode: isLgbtMode,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return Scaffold(
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHomeDashboard(isLgbtMode, user),
              TransferScreen(user: user),
              DatingScreen(user: user),
              const ChatbotScreen(),
              AuraExchangeScreen(onBack: () => setState(() => _selectedIndex = 0)),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: isLgbtMode
                  ? AppShadow.soft
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
              border: Border(
                top: BorderSide(
                  color: isLgbtMode ? AppColors.line : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onNavTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: isLgbtMode ? AppColors.hotPink : Colors.black,
              unselectedItemColor: isLgbtMode ? AppColors.inkMuted : const Color(0xFF64748B),
              selectedLabelStyle: isLgbtMode
                  ? GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 12)
                  : GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 12),
              unselectedLabelStyle: isLgbtMode
                  ? GoogleFonts.fredoka(fontWeight: FontWeight.w500, fontSize: 11)
                  : GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 11),
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: isLgbtMode ? 'Home' : 'Home',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.send_rounded),
                  label: isLgbtMode ? 'Transfer' : 'Transfer',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.favorite_rounded),
                  label: isLgbtMode ? 'Dating' : 'Dating',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.smart_toy_rounded),
                  label: isLgbtMode ? 'Chat' : 'Chat',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.show_chart_rounded),
                  label: isLgbtMode ? 'Invest' : 'Invest',
                ),
              ],
            ),
          ),
        );
      },
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
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
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
  final bool isLgbtMode;

  const _ActivityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isNegative,
    required this.isLgbtMode,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor = isLgbtMode
        ? (isNegative ? AppColors.hotPink : AppColors.limeGreen)
        : Colors.black;

    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: tileColor.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: tileColor, size: 20),
      ),
      title: Text(
        title,
        style: isLgbtMode
            ? GoogleFonts.fredoka(fontSize: 14.5, fontWeight: FontWeight.w600)
            : GoogleFonts.inter(
                fontSize: 14.5,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          color: isLgbtMode ? AppColors.inkMuted : const Color(0xFF6B7280),
        ),
      ),
      trailing: Text(
        amount,
        style: isLgbtMode
            ? GoogleFonts.fredoka(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: tileColor,
              )
            : GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.black,
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
  final bool isLgbtMode;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.badgeText,
    required this.accentColor,
    required this.onTap,
    required this.isLgbtMode,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isLgbtMode ? 20 : 12),
          border: Border.all(
            color: isLgbtMode ? AppColors.line : const Color(0xFFCBD5E1),
            width: 1.5,
          ),
          boxShadow: isLgbtMode
              ? AppShadow.soft
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(isLgbtMode ? 10 : 8),
                  ),
                  child: Icon(icon, color: accentColor, size: 18),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isLgbtMode
                      ? GoogleFonts.fredoka(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        )
                      : GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
