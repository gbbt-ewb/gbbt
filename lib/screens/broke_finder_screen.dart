import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

// Note: this screen shows CITY-LEVEL AVERAGES only — never an individual
// account balance tied to a specific person or exact location. Pinning a
// real person's wealth to a map is a genuine safety risk (it's exactly
// the info used to target people for robbery/extortion), so this stays
// aggregated and anonymized, same as the models.dart comment explains.
class BrokeFinderScreen extends StatelessWidget {
  const BrokeFinderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sorted = [...mockCityWealth]..sort((a, b) => b.avgSavings.compareTo(a.avgSavings));

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
                  const RainbowShimmerText(text: 'BrokeFinder 🗺️', fontSize: 24),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline_rounded, size: 14, color: AppColors.inkMuted),
                    const SizedBox(width: 6),
                    Text(
                      'City averages only — no individual accounts shown',
                      style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Stylized map — bubble size/color = average savings for that city.
              BonggaCard(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1.05,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Stack(
                        children: [
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Color(0xFFE8F0FE), Color(0xFFFBE4FF)],
                                ),
                              ),
                            ),
                          ),
                          for (final city in mockCityWealth)
                            _CityBubble(
                              city: city,
                              left: city.mapX * constraints.maxWidth,
                              top: city.mapY * constraints.maxHeight,
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Broke-o-Meter Leaderboard', style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
                  const InteractiveSticker(text: '💸 RANKED', rotateAngle: 0.04),
                ],
              ),
              const SizedBox(height: 12),

              ...sorted.asMap().entries.map((entry) {
                final rank = entry.key + 1;
                final city = entry.value;
                return _CityRow(rank: rank, city: city);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _CityBubble extends StatelessWidget {
  final CityWealth city;
  final double left;
  final double top;
  const _CityBubble({required this.city, required this.left, required this.top});

  double get _size {
    // Scale bubble diameter with average savings, clamped to a sane range.
    final scaled = 34 + (city.avgSavings / 620000) * 46;
    return scaled.clamp(34, 80);
  }

  @override
  Widget build(BuildContext context) {
    final size = _size;
    return Positioned(
      left: left - size / 2,
      top: top - size / 2,
      child: GestureDetector(
        onTap: () => _showCityDetail(context, city),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: electricRainbowGradient,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: AppShadow.soft,
          ),
          child: Center(
            child: Text(
              city.city.length > 3 ? city.city.substring(0, 3).toUpperCase() : city.city.toUpperCase(),
              style: GoogleFonts.fredoka(color: Colors.white, fontSize: size * 0.22, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ),
    );
  }

  void _showCityDetail(BuildContext context, CityWealth city) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(city.city, style: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 4),
            InteractiveSticker(text: city.vibe, rotateAngle: -0.03),
            const SizedBox(height: 16),
            _statLine('Average savings', '₱${city.avgSavings.toStringAsFixed(0)}'),
            _statLine('GBBT accounts here', '${city.accountCount}'),
            const SizedBox(height: 8),
            Text(
              'Aggregated & anonymized — this is a city average, not any individual\'s balance.',
              style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.inkMuted, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 13.5)),
          Text(value, style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.hotPink)),
        ],
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  final int rank;
  final CityWealth city;
  const _CityRow({required this.rank, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadow.soft,
        border: Border.all(color: AppColors.line, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: AppColors.electricPurple.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text('#$rank', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: AppColors.electricPurple, fontSize: 13))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city.city, style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 14.5, color: AppColors.ink)),
                Text(city.vibe, style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.inkMuted)),
              ],
            ),
          ),
          Text('₱${city.avgSavings.toStringAsFixed(0)}', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.hotPink)),
        ],
      ),
    );
  }
}
