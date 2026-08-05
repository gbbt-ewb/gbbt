import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

// Note: Aura Score here comes from mock ENGAGEMENT stats (login streaks,
// chatbot activity, referrals) — it's deliberately not connected to Vibe
// Check or any camera/photo, so nobody's "investment value" is tied to
// how they look.
class AuraExchangeScreen extends StatefulWidget {
  const AuraExchangeScreen({super.key});

  @override
  State<AuraExchangeScreen> createState() => _AuraExchangeScreenState();
}

class _AuraExchangeScreenState extends State<AuraExchangeScreen> {
  double _coins = 5000;

  @override
  Widget build(BuildContext context) {
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
                  const RainbowShimmerText(text: 'Aura Exchange 📈', fontSize: 24),
                ],
              ),
              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: electricRainbowGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadow.lifted,
                ),
                child: Column(
                  children: [
                    const Text('📈', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 8),
                    Text('Aura Exchange ✨', style: GoogleFonts.fredoka(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(
                      'Invest GBBT Coins in your besties\' Aura — powered by streaks & sass, not selfies. 💅',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white.withOpacity(0.92), fontSize: 13),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.22), borderRadius: BorderRadius.circular(20)),
                      child: Text('💰 ${_coins.toStringAsFixed(0)} GBBT Coins available', style: GoogleFonts.fredoka(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text('Trending Auras', style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
              const SizedBox(height: 12),

              ...mockAuraStocks.map((stock) => _AuraStockCard(
                    stock: stock,
                    onInvest: (amount) => _handleInvest(stock, amount),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  void _handleInvest(AuraStock stock, double amount) {
    if (amount > _coins) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Not enough GBBT Coins, bestie! 💸")),
      );
      return;
    }
    setState(() => _coins -= amount);
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🚀', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              InteractiveSticker(text: '💸 INVESTED IN ${stock.name.toUpperCase()}', rotateAngle: -0.03),
              const SizedBox(height: 14),
              Text('Aura Stake Confirmed!', style: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.ink), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(
                'You put ${amount.toStringAsFixed(0)} GBBT Coins behind ${stock.name}\'s aura. May their streaks stay strong! 🌈',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 13.5, color: AppColors.inkMuted, height: 1.4),
              ),
              const SizedBox(height: 24),
              GradientButton(
                label: 'SLAY! 💅',
                icon: Icons.check_circle_rounded,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AuraStockCard extends StatelessWidget {
  final AuraStock stock;
  final void Function(double amount) onInvest;
  const _AuraStockCard({required this.stock, required this.onInvest});

  @override
  Widget build(BuildContext context) {
    final isUp = stock.changePercent >= 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        boxShadow: AppShadow.soft,
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(gradient: electricRainbowGradient, shape: BoxShape.circle),
                child: Center(child: Text(stock.name[0], style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stock.name, style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.ink)),
                    Text(stock.tagline, style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₱${stock.pricePerShare.toStringAsFixed(2)}', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.ink)),
                  Text(
                    '${isUp ? '▲' : '▼'} ${stock.changePercent.abs().toStringAsFixed(1)}%',
                    style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 12, color: isUp ? AppColors.limeGreen : AppColors.hotPink),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text('Aura Score', style: GoogleFonts.inter(fontSize: 12, color: AppColors.inkMuted)),
              ),
              Text('${stock.auraScore}/100', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.electricPurple)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: stock.auraScore / 100,
              minHeight: 8,
              backgroundColor: AppColors.line,
              valueColor: const AlwaysStoppedAnimation(AppColors.electricPurple),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _investChip(context, 100),
              const SizedBox(width: 8),
              _investChip(context, 500),
              const SizedBox(width: 8),
              _investChip(context, 1000),
            ],
          ),
        ],
      ),
    );
  }

  Widget _investChip(BuildContext context, double amount) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () => onInvest(amount),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          foregroundColor: AppColors.hotPink,
          side: const BorderSide(color: AppColors.hotPink, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text('+${amount.toStringAsFixed(0)}', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 12.5)),
      ),
    );
  }
}
