import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class AuraExchangeScreen extends StatefulWidget {
  const AuraExchangeScreen({super.key});

  @override
  State<AuraExchangeScreen> createState() =>
      _AuraExchangeScreenState();
}

class _AuraExchangeScreenState
    extends State<AuraExchangeScreen> {
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
    return mockAuraStocks
            .map((e) => e.auraScore)
            .reduce((a, b) => a + b) /
        mockAuraStocks.length;
  }

  void _claimReward() {
    if (_claimedReward) return;

    setState(() {
      _coins += 250;
      _claimedReward = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          '🎁 Daily reward claimed! +250 Coins',
        ),
      ),
    );
  }

  void _handleInvest(
    AuraStock stock,
    double amount,
  ) {
    if (amount > _coins) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Not enough GBBT Coins 💸',
          ),
        ),
      );
      return;
    }

    setState(() {
      _coins -= amount;

      _portfolio[stock.name] =
          (_portfolio[stock.name] ?? 0) +
              amount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🚀 Invested ${amount.toStringAsFixed(0)} coins into ${stock.name}',
        ),
      ),
    );
  }

  void _sell(
    AuraStock stock,
    double amount,
  ) {
    final current =
        _portfolio[stock.name] ?? 0;

    if (current < amount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Not enough holdings'),
        ),
      );
      return;
    }

    setState(() {
      _portfolio[stock.name] =
          current - amount;
      _coins += amount;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '💰 Sold ${amount.toStringAsFixed(0)} coins from ${stock.name}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Aura Exchange 📈',
                  style:
                      GoogleFonts.fredoka(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient:
                    electricRainbowGradient,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
                boxShadow:
                    AppShadow.lifted,
              ),
              child: Column(
                children: [
                  const Text(
                    '💰',
                    style: TextStyle(
                      fontSize: 44,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${_coins.toStringAsFixed(0)} GBBT Coins',
                    style:
                        GoogleFonts.fredoka(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    'Available Balance',
                    style:
                        GoogleFonts.inter(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            GradientButton(
              label: _claimedReward
                  ? 'Reward Claimed ✅'
                  : 'Claim Daily Reward 🎁',
              onPressed:
                  _claimedReward
                      ? null
                      : _claimReward,
            ),

            const SizedBox(height: 20),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
                boxShadow:
                    AppShadow.soft,
              ),
              child: Column(
                children: [
                  const Text(
                    '📊 Aura Index',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    _auraIndex
                        .toStringAsFixed(1),
                    style:
                        const TextStyle(
                      fontSize: 42,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'The vibes are bullish today ✨',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
                boxShadow:
                    AppShadow.soft,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🏆 Top Auras',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                      '🥇 Sam'),
                  const Text(
                      '🥈 Andi'),
                  const Text(
                      '🥉 Jamie'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding:
                  const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(
                  24,
                ),
                boxShadow:
                    AppShadow.soft,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    '💼 Portfolio',
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Total Invested: ${_portfolioValue.toStringAsFixed(0)} Coins',
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (_portfolio.isEmpty)
                    const Text(
                      'No investments yet.',
                    ),
                  ..._portfolio.entries.map(
                    (entry) => ListTile(
                      title: Text(
                        entry.key,
                      ),
                      trailing: Text(
                        '${entry.value.toStringAsFixed(0)} Coins',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Trending Auras',
              style:
                  GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            ...mockAuraStocks.map(
              (stock) => _AuraStockCard(
                stock: stock,
                investedAmount:
                    _portfolio[stock.name] ??
                        0,
                onInvest: (amount) =>
                    _handleInvest(
                  stock,
                  amount,
                ),
                onSell: (amount) =>
                    _sell(
                  stock,
                  amount,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuraStockCard extends StatelessWidget {
  final AuraStock stock;
  final double investedAmount;
  final Function(double) onInvest;
  final Function(double) onSell;

  const _AuraStockCard({
    required this.stock,
    required this.investedAmount,
    required this.onInvest,
    required this.onSell,
  });

  @override
  Widget build(BuildContext context) {
    final isUp =
        stock.changePercent >= 0;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 16,
      ),
      padding:
          const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          24,
        ),
        boxShadow:
            AppShadow.soft,
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                child: Text(
                  stock.name[0],
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      stock.name,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                    Text(
                      stock.tagline,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '₱${stock.pricePerShare}',
                  ),
                  Text(
                    '${isUp ? "▲" : "▼"} ${stock.changePercent.toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: isUp
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value:
                stock.auraScore / 100,
          ),

          const SizedBox(height: 8),

          Text(
            'Aura Score ${stock.auraScore}/100',
          ),

          const SizedBox(height: 12),

          if (investedAmount > 0)
            Text(
              'Holding: ${investedAmount.toStringAsFixed(0)} Coins',
              style: const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton(
                  onPressed: () =>
                      onInvest(100),
                  child: const Text(
                      '+100'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child:
                    OutlinedButton(
                  onPressed: () =>
                      onInvest(500),
                  child: const Text(
                      '+500'),
                ),
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child:
                    FilledButton(
                  onPressed: () =>
                      onSell(100),
                  child:
                      const Text(
                    'Sell',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}