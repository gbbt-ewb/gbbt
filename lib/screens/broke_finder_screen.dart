import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// Note: this screen shows CITY-LEVEL AVERAGES only — never an individual
// account balance tied to a specific person or exact location. Pinning a
// real person's wealth to a map is a genuine safety risk (it's exactly
// the info used to target people for robbery/extortion), so this stays
// aggregated and anonymized, same as the models.dart comment explains.
class BrokeFinderScreen extends StatefulWidget {
  const BrokeFinderScreen({super.key});

  @override
  State<BrokeFinderScreen> createState() => _BrokeFinderScreenState();
}

class _BrokeFinderScreenState extends State<BrokeFinderScreen> {
  final MapController _mapController = MapController();

  double _zoom = 5.3;

  Color _pinColor(double savings) {
    if (savings >= 800000) {
      return const Color(0xFF006D32);
    } else if (savings >= 500000) {
      return Colors.green;
    } else if (savings >= 300000) {
      return Colors.lime;
    } else if (savings >= 200000) {
      return Colors.orange;
    } else if (savings >= 100000) {
      return Colors.deepOrange;
    }
    return Colors.red;
  }

  double _pinSize(double savings) {
    if (savings >= 800000) return 58;
    if (savings >= 500000) return 52;
    if (savings >= 300000) return 46;
    if (savings >= 200000) return 42;
    if (savings >= 100000) return 38;
    return 34;
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...mockCityWealth]
      ..sort((a, b) => b.avgSavings.compareTo(a.avgSavings));

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
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 20,
                      color: AppColors.ink,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const RainbowShimmerText(
                    text: 'BrokeFinder 🗺️',
                    fontSize: 24,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      size: 14,
                      color: AppColors.inkMuted,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'City averages only — no individual accounts shown',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Stylized map — bubble size/color = average savings for that city.
              BonggaCard(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: 350,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: const LatLng(12.8797, 121.7740),
                            initialZoom: _zoom,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.gbbt_bank',
                            ),
                            MarkerLayer(
                              markers: mockCityWealth.map((city) {
                                final pinColor = _pinColor(city.avgSavings);
                                final pinSize = _pinSize(city.avgSavings);

                                return Marker(
                                  point: LatLng(city.latitude, city.longitude),
                                  width: 100,
                                  height: 85,
                                  child: GestureDetector(
                                    onTap: () => _showCityDetail(context, city),
                                    child: Tooltip(
                                      message:
                                          '${city.city}\n₱${city.avgSavings.toStringAsFixed(0)} Avg Savings',
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: pinColor,
                                            size: pinSize,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(
                                                .95,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              city.city,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.inter(
                                                fontSize: 9,
                                                fontWeight: FontWeight.w700,
                                                color: pinColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.96),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: AppShadow.soft,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Savings Legend',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                _legendRow(const Color(0xFF006D32), '₱800k+'),

                                _legendRow(Colors.green, '₱500k - ₱799k'),

                                _legendRow(Colors.lime, '₱300k - ₱499k'),

                                _legendRow(Colors.orange, '₱200k - ₱299k'),

                                _legendRow(Colors.deepOrange, '₱100k - ₱199k'),

                                _legendRow(Colors.red, '< ₱100k'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Broke-o-Meter Leaderboard',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const InteractiveSticker(
                    text: '💸 RANKED',
                    rotateAngle: 0.04,
                  ),
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

  void _showCityDetail(BuildContext context, CityWealth city) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              city.city,
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 8),
            InteractiveSticker(text: city.vibe, rotateAngle: -0.03),
            const SizedBox(height: 16),
            _statLine(
              'Average Savings',
              '₱${city.avgSavings.toStringAsFixed(0)}',
            ),
            _statLine('GBBT Accounts', '${city.accountCount}'),
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
          Text(label, style: GoogleFonts.inter(color: AppColors.inkMuted)),
          Text(
            value,
            style: GoogleFonts.fredoka(
              color: AppColors.hotPink,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendRow(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 11, color: AppColors.ink),
          ),
        ],
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  final int rank;
  final CityWealth city;
  Color _getPinColor(double savings) {
    if (savings >= 800000) {
      return const Color(0xFF006D32);
    } else if (savings >= 500000) {
      return Colors.green;
    } else if (savings >= 300000) {
      return Colors.lime;
    } else if (savings >= 200000) {
      return Colors.orange;
    } else if (savings >= 100000) {
      return Colors.deepOrange;
    }
    return Colors.red;
  }

  const _CityRow({required this.rank, required this.city});

  @override
  Widget build(BuildContext context) {
    final pinColor = _getPinColor(city.avgSavings);

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
            decoration: BoxDecoration(
              color: pinColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: pinColor, width: 1.5),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: GoogleFonts.fredoka(
                  fontWeight: FontWeight.w700,
                  color: pinColor,
                  fontSize: 13,
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
                  city.city,
                  style: GoogleFonts.fredoka(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.5,
                    color: pinColor,
                  ),
                ),
                Text(
                  city.vibe,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₱${city.avgSavings.toStringAsFixed(0)}',
            style: GoogleFonts.fredoka(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: pinColor,
            ),
          ),
        ],
      ),
    );
  }
}
