import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class AuraExchangeScreen extends StatefulWidget {
  const AuraExchangeScreen({super.key});

  @override
  State<AuraExchangeScreen> createState() => _AuraExchangeScreenState();
}

class _AuraExchangeScreenState extends State<AuraExchangeScreen> {
  double _coins = 5000;
  bool _claimedReward = false;
  final Map<String, double> _portfolio = {};

  double get _portfolioValue {
    double total = 0;
    for (final value in _portfolio.values) {
      total += value;
    }
    return total;
  }

  double get _auraIndex {
    if (mockAuraStocks.isEmpty) return 100.0;
    return mockAuraStocks.map((e) => e.auraScore).reduce((a, b) => a + b) / mockAuraStocks.length;
  }

  void _claimReward() {
    if (_claimedReward) return;

    FunAudioPlayer.playPopupFanfare();
    setState(() {
      _coins += 250;
      _claimedReward = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppModeController.instance.isLgbtMode ? AppColors.ink : Colors.black,
        content: Text(
          '🎁 Daily reward claimed (+250 GBBT Coins)!',
          style: AppModeController.instance.isLgbtMode ? GoogleFonts.fredoka() : GoogleFonts.inter(),
        ),
      ),
    );
  }

  void _handleInvest(AuraStock stock, double amount) {
    if (amount > _coins) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppModeController.instance.isLgbtMode ? AppColors.hotPink : Colors.black,
          content: Text(
            'Not enough GBBT Coins 💸',
            style: AppModeController.instance.isLgbtMode ? GoogleFonts.fredoka() : GoogleFonts.inter(),
          ),
        ),
      );
      return;
    }

    FunAudioPlayer.playStickerPop();
    setState(() {
      _coins -= amount;
      _portfolio[stock.name] = (_portfolio[stock.name] ?? 0) + amount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppModeController.instance.isLgbtMode ? AppColors.ink : Colors.black,
        content: Text(
          '🚀 Invested ${amount.toStringAsFixed(0)} coins into ${stock.name}!',
          style: AppModeController.instance.isLgbtMode ? GoogleFonts.fredoka() : GoogleFonts.inter(),
        ),
      ),
    );
  }

  void _sell(AuraStock stock, double amount) {
    final current = _portfolio[stock.name] ?? 0;

    if (current < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppModeController.instance.isLgbtMode ? AppColors.hotPink : Colors.black,
          content: Text(
            'Not enough holdings to sell!',
            style: AppModeController.instance.isLgbtMode ? GoogleFonts.fredoka() : GoogleFonts.inter(),
          ),
        ),
      );
      return;
    }

    FunAudioPlayer.playPassSound();
    setState(() {
      _portfolio[stock.name] = current - amount;
      _coins += amount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppModeController.instance.isLgbtMode ? AppColors.ink : Colors.black,
        content: Text(
          '💰 Sold ${amount.toStringAsFixed(0)} coins from ${stock.name}!',
          style: AppModeController.instance.isLgbtMode ? GoogleFonts.fredoka() : GoogleFonts.inter(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
        return Scaffold(
          body: BonggaBackground(
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                children: [
                  // Top Bar Header
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.arrow_back_ios_new, size: 18, color: isLgbtMode ? AppColors.ink : Colors.black),
                        style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: RainbowShimmerText(
                          text: 'Aura Exchange 📈',
                          fontSize: 22,
                        ),
                      ),
                      InteractiveSticker(
                        text: isLgbtMode ? '🚀 BULLISH' : 'MARKET',
                        backgroundColor: isLgbtMode ? AppColors.limeGreen : const Color(0xFFF3F4F6),
                        textColor: isLgbtMode ? AppColors.ink : Colors.black,
                        rotateAngle: isLgbtMode ? 0.04 : 0.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Available Balance Card
                  BonggaCard(
                    padding: EdgeInsets.zero,
                    hasRainbowGlow: true,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(isLgbtMode ? 24 : 14),
                        gradient: isLgbtMode
                            ? electricRainbowGradient
                            : const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF111111), Color(0xFF222222)],
                              ),
                      ),
                      child: Column(
                        children: [
                          const Text('💰', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 8),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${_coins.toStringAsFixed(0)} GBBT Coins',
                              style: isLgbtMode
                                  ? GoogleFonts.fredoka(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    )
                                  : GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isLgbtMode ? 'Available Balance ✨' : 'Available Balance',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daily Reward Button
                  GradientButton(
                    label: _claimedReward ? 'Reward Claimed ✅' : 'Claim Daily Reward (+250) 🎁',
                    icon: Icons.card_giftcard_rounded,
                    onPressed: _claimedReward ? null : _claimReward,
                  ),
                  const SizedBox(height: 20),

                  // Aura Index & Top Auras Row
                  Row(
                    children: [
                      Expanded(
                        child: BonggaCard(
                          hasRainbowGlow: false,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                '📊 Aura Index',
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: AppColors.ink,
                                      )
                                    : GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _auraIndex.toStringAsFixed(1),
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.hotPink,
                                      )
                                    : GoogleFonts.inter(
                                        fontSize: 36,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isLgbtMode ? 'Bullish Vibes ✨' : 'Market Index',
                                style: GoogleFonts.inter(
                                  fontSize: 11.5,
                                  color: isLgbtMode ? AppColors.inkMuted : const Color(0xFF6B7280),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BonggaCard(
                          hasRainbowGlow: false,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '🏆 Top Auras',
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: AppColors.ink,
                                      )
                                    : GoogleFonts.inter(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '🥇 Sam · 98.4%',
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(fontSize: 13, color: AppColors.ink)
                                    : GoogleFonts.inter(fontSize: 13, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '🥈 Andi · 94.2%',
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(fontSize: 13, color: AppColors.ink)
                                    : GoogleFonts.inter(fontSize: 13, color: Colors.black),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '🥉 Jamie · 91.0%',
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(fontSize: 13, color: AppColors.ink)
                                    : GoogleFonts.inter(fontSize: 13, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Portfolio Summary Card
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
                              '💼 Portfolio Holdings',
                              style: isLgbtMode
                                  ? GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: AppColors.ink,
                                    )
                                  : GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                            ),
                            Text(
                              '${_portfolioValue.toStringAsFixed(0)} Coins',
                              style: isLgbtMode
                                  ? GoogleFonts.fredoka(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: AppColors.hotPink,
                                    )
                                  : GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (_portfolio.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'No investments yet. Buy some auras below!',
                              style: GoogleFonts.inter(
                                color: isLgbtMode ? AppColors.inkMuted : const Color(0xFF6B7280),
                                fontSize: 13,
                              ),
                            ),
                          )
                        else
                          Material(
                            color: Colors.transparent,
                            child: Column(
                              children: _portfolio.entries.map((entry) {
                                if (entry.value <= 0) return const SizedBox();
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: isLgbtMode ? AppColors.cream : const Color(0xFFF3F4F6),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: isLgbtMode
                                            ? GoogleFonts.fredoka(
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.ink,
                                                fontSize: 14,
                                              )
                                            : GoogleFonts.inter(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                      ),
                                      Text(
                                        '${entry.value.toStringAsFixed(0)} Coins',
                                        style: isLgbtMode
                                            ? GoogleFonts.fredoka(
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.electricPurple,
                                                fontSize: 14,
                                              )
                                            : GoogleFonts.inter(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                fontSize: 14,
                                              ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Trending Auras Section Title
                  Text(
                    'Trending Auras 🔥',
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
                  const SizedBox(height: 12),

                  // Aura Stock Cards List
                  ...mockAuraStocks.map(
                    (stock) => _AuraStockCard(
                      stock: stock,
                      investedAmount: _portfolio[stock.name] ?? 0,
                      onInvest: (amount) => _handleInvest(stock, amount),
                      onSell: (amount) => _sell(stock, amount),
                      isLgbtMode: isLgbtMode,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AuraStockCard extends StatelessWidget {
  final AuraStock stock;
  final double investedAmount;
  final Function(double) onInvest;
  final Function(double) onSell;
  final bool isLgbtMode;

  const _AuraStockCard({
    required this.stock,
    required this.investedAmount,
    required this.onInvest,
    required this.onSell,
    required this.isLgbtMode,
  });

  @override
  Widget build(BuildContext context) {
    final isUp = stock.changePercent >= 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: BonggaCard(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: isLgbtMode ? electricRainbowGradient : null,
                    color: isLgbtMode ? null : const Color(0xFF111111),
                    shape: BoxShape.circle,
                    boxShadow: isLgbtMode ? AppShadow.soft : null,
                  ),
                  child: Center(
                    child: Text(
                      stock.name[0],
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stock.name,
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: AppColors.ink,
                              )
                            : GoogleFonts.inter(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: Colors.black,
                              ),
                      ),
                      Text(
                        stock.tagline,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: isLgbtMode ? AppColors.inkMuted : const Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₱${stock.pricePerShare}',
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: AppColors.ink,
                            )
                          : GoogleFonts.inter(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isLgbtMode
                            ? (isUp ? AppColors.limeGreen : AppColors.hotPink).withOpacity(0.15)
                            : const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${isUp ? "▲ +" : "▼ "}${stock.changePercent.toStringAsFixed(1)}%',
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(
                                color: isUp ? AppColors.limeGreen : AppColors.hotPink,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              )
                            : GoogleFonts.inter(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Aura Score Progress Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Aura Score',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: isLgbtMode ? AppColors.inkMuted : const Color(0xFF6B7280),
                  ),
                ),
                Text(
                  '${stock.auraScore.toStringAsFixed(0)}/100',
                  style: isLgbtMode
                      ? GoogleFonts.fredoka(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: AppColors.electricPurple,
                        )
                      : GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.black,
                        ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: stock.auraScore / 100,
                minHeight: 8,
                backgroundColor: isLgbtMode ? AppColors.line : const Color(0xFFE5E7EB),
                valueColor: AlwaysStoppedAnimation<Color>(
                  isLgbtMode
                      ? (isUp ? AppColors.limeGreen : AppColors.hotPink)
                      : Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onSell(100),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isLgbtMode ? AppColors.hotPink : Colors.black,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isLgbtMode ? 14 : 8),
                      ),
                    ),
                    child: Text(
                      'Sell 100',
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(color: AppColors.hotPink, fontWeight: FontWeight.w600)
                          : GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => onInvest(100),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLgbtMode ? AppColors.electricPurple : Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(isLgbtMode ? 14 : 8),
                      ),
                    ),
                    child: Text(
                      'Buy 100 🚀',
                      style: isLgbtMode
                          ? GoogleFonts.fredoka(fontWeight: FontWeight.w600)
                          : GoogleFonts.inter(fontWeight: FontWeight.w600),
                    ),
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