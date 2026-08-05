import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../models.dart';
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

    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';

    return 'Good evening';
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => const WelcomeScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            24,
          ),
          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    gradient: rainbowGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$_greeting,",
                        style:
                            Theme.of(context)
                                .textTheme
                                .bodySmall,
                      ),
                      Text(
                        user.firstName,
                        style:
                            Theme.of(context)
                                .textTheme
                                .headlineSmall,
                      ),
                    ],
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: IconButton(
                    onPressed: _logout,
                    icon: const Icon(
                      Icons.logout_rounded,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// BALANCE CARD
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(28),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: rainbowGradient,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        Text(
                          'Available Balance',
                          style: TextStyle(
                            color: Colors.white
                                .withOpacity(.85),
                            fontSize: 13,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _balanceVisible =
                                  !_balanceVisible;
                            });
                          },
                          child: Icon(
                            _balanceVisible
                                ? Icons
                                    .visibility_outlined
                                : Icons
                                    .visibility_off_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Text(
                      _balanceVisible
                          ? '₱${user.savings.toStringAsFixed(2)}'
                          : '₱ • • • • • •',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(.20),
                        borderRadius:
                            BorderRadius.circular(
                              20,
                            ),
                      ),
                      child: const Text(
                        '🌟 Gold Member',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      user.taxBracket,
                      style: TextStyle(
                        color: Colors.white
                            .withOpacity(.90),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// FINANCIAL HEALTH
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: AppShadow.soft,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Financial Health",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                                20,
                              ),
                          child:
                              LinearProgressIndicator(
                                value:
                                    user.savings >
                                            100000
                                        ? .92
                                        : .67,
                                minHeight: 12,
                              ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        user.savings > 100000
                            ? "92%"
                            : "67%",
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Text(
                    user.savings > 100000
                        ? "Excellent savings habits 🎉"
                        : "Keep building your savings 💪",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// QUICK ACTIONS
            Text(
              "Quick Actions",
              style:
                  Theme.of(context)
                      .textTheme
                      .titleMedium,
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
              children: const [
                _QuickAction(
                  icon: Icons.send,
                  title: 'Transfer',
                  color: Colors.blue,
                ),
                _QuickAction(
                  icon: Icons.savings,
                  title: 'Save',
                  color: Colors.green,
                ),
                _QuickAction(
                  icon: Icons.bar_chart,
                  title: 'Invest',
                  color: Colors.purple,
                ),
                _QuickAction(
                  icon: Icons.receipt_long,
                  title: 'Bills',
                  color: Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 28),

            /// FEATURES
            Text(
              'Features',
              style:
                  Theme.of(context)
                      .textTheme
                      .titleMedium,
            ),

            const SizedBox(height: 12),

            GridView.count(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                _FeatureCard(
                  icon: Icons.send_rounded,
                  label: 'Bank Transfer',
                  subtitle:
                      'Free for LGBTQIA+',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            TransferScreen(
                              user: user,
                            ),
                      ),
                    );
                  },
                ),
                _FeatureCard(
                  icon:
                      Icons
                          .chat_bubble_outline_rounded,
                  label: 'Chatbot',
                  subtitle:
                      'Ask GBBT anything',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const ChatbotScreen(),
                      ),
                    );
                  },
                ),
                _FeatureCard(
                  icon:
                      Icons.favorite_border_rounded,
                  label: 'Money Match',
                  subtitle:
                      'Date by tax bracket',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DatingScreen(
                              user: user,
                            ),
                      ),
                    );
                  },
                ),
                _FeatureCard(
                  icon:
                      Icons.auto_awesome_outlined,
                  label: 'Vibe Check',
                  subtitle:
                      'Certified fabulous?',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const VibeCheckScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// RECENT ACTIVITY
            Text(
              'Recent Activity',
              style:
                  Theme.of(context)
                      .textTheme
                      .titleMedium,
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: AppShadow.soft,
              ),
              child: const Column(
                children: [
                  _ActivityTile(
                    icon: Icons.send,
                    title: 'Transfer to Jamie',
                    amount: '- ₱2,500',
                  ),
                  Divider(height: 1),
                  _ActivityTile(
                    icon: Icons.savings,
                    title: 'Savings Deposit',
                    amount: '+ ₱10,000',
                  ),
                  Divider(height: 1),
                  _ActivityTile(
                    icon: Icons.favorite,
                    title:
                        'Money Match Premium',
                    amount: '- ₱99',
                  ),
                ],
              ),
            ),
          ],
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
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: AppShadow.soft,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors
                    .lavender
                    .withOpacity(.35),
                borderRadius:
                    BorderRadius.circular(
                      14,
                    ),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
              ),
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                fontWeight:
                    FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.5,
                color: AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}