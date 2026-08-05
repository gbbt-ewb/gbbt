import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models.dart';
import 'welcome_screen.dart';
import 'transfer_screen.dart';
import 'chatbot_screen.dart';
import 'dating_screen.dart';
import 'vibe_check_screen.dart';

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
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const WelcomeScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(gradient: rainbowGradient, shape: BoxShape.circle),
                  child: Center(child: Text(user.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$_greeting,', style: Theme.of(context).textTheme.bodySmall),
                      Text(user.firstName, style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout_rounded),
                  style: IconButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.ink),
                ),
              ],
            ),
            const SizedBox(height: 24),

            ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(gradient: rainbowGradient),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Available Balance', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 13)),
                        InkWell(
                          onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                          child: Icon(
                            _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _balanceVisible ? '₱${user.savings.toStringAsFixed(2)}' : '₱ • • • • • •',
                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(user.taxBracket, style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.5, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),

            Text('Features', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                _FeatureCard(
                  icon: Icons.send_rounded,
                  label: 'Bank Transfer',
                  subtitle: 'Free for LGBTQIA+',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => TransferScreen(user: user))),
                ),
                _FeatureCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Chatbot',
                  subtitle: 'Ask GBBT anything',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ChatbotScreen())),
                ),
                _FeatureCard(
                  icon: Icons.favorite_border_rounded,
                  label: 'Money Match',
                  subtitle: 'Date by tax bracket',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => DatingScreen(user: user))),
                ),
                _FeatureCard(
                  icon: Icons.auto_awesome_outlined,
                  label: 'Vibe Check',
                  subtitle: 'Certified fabulous?',
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VibeCheckScreen())),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _FeatureCard({required this.icon, required this.label, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadow.soft),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.35), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: AppColors.primary),
            ),
            const Spacer(),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
          ],
        ),
      ),
    );
  }
}
