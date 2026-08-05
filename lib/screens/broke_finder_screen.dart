import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BrokeFinderScreen extends StatefulWidget {
  const BrokeFinderScreen({super.key});

  @override
  State<BrokeFinderScreen> createState() => _BrokeFinderScreenState();
}

class _BrokeFinderScreenState extends State<BrokeFinderScreen> {
  final MapController _mapController = MapController();

  double _zoom = 5.3;

  @override
  Widget build(BuildContext context) {
    final sorted = [...mockCityWealth]
      ..sort((a, b) => b.avgSavings.compareTo(a.avgSavings));

    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
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
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: 20,
                          color: isLgbtMode ? AppColors.ink : Colors.black,
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
                        Icon(
                          Icons.lock_outline_rounded,
                          size: 14,
                          color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'City averages only — no individual accounts shown',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
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
                        borderRadius: BorderRadius.circular(isLgbtMode ? 20 : 12),
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
                                    return Marker(
                                      point: LatLng(city.latitude, city.longitude),
                                      width: 50,
                                      height: 50,
                                      child: GestureDetector(
                                        onTap: () => _showCityDetail(context, city, isLgbtMode),
                                        child: Icon(
                                          Icons.location_on,
                                          color: isLgbtMode
                                              ? (city.avgSavings >= 500000
                                                  ? Colors.green
                                                  : city.avgSavings >= 200000
                                                  ? Colors.orange
                                                  : Colors.red)
                                              : Colors.black,
                                          size: 40,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),

                            Positioned(
                              top: 12,
                              right: 12,
                              child: Column(
                                children: [
                                  FloatingActionButton.small(
                                    heroTag: 'zoomIn',
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _zoom++;
                                      });

                                      _mapController.move(
                                        _mapController.camera.center,
                                        _zoom,
                                      );
                                    },
                                    child: const Icon(Icons.add, color: Colors.black),
                                  ),
                                  const SizedBox(height: 8),
                                  FloatingActionButton.small(
                                    heroTag: 'zoomOut',
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      setState(() {
                                        _zoom--;
                                      });

                                      _mapController.move(
                                        _mapController.camera.center,
                                        _zoom,
                                      );
                                    },
                                    child: const Icon(Icons.remove, color: Colors.black),
                                  ),
                                ],
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
                        style: isLgbtMode
                            ? GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              )
                            : GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                      ),
                      InteractiveSticker(
                        text: isLgbtMode ? '💸 RANKED' : 'RANKED',
                        rotateAngle: isLgbtMode ? 0.04 : 0.0,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...sorted.asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    final city = entry.value;
                    return _CityRow(rank: rank, city: city, isLgbtMode: isLgbtMode);
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCityDetail(BuildContext context, CityWealth city, bool isLgbtMode) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(isLgbtMode ? 28 : 16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              city.city,
              style: isLgbtMode
                  ? GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    )
                  : GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
            ),
            const SizedBox(height: 8),
            InteractiveSticker(text: city.vibe, rotateAngle: isLgbtMode ? -0.03 : 0.0),
            const SizedBox(height: 16),
            _statLine(
              'Average Savings',
              '₱${city.avgSavings.toStringAsFixed(0)}',
              isLgbtMode,
            ),
            _statLine('GBBT Accounts', '${city.accountCount}', isLgbtMode),
          ],
        ),
      ),
    );
  }

  Widget _statLine(String label, String value, bool isLgbtMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.inter(color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700])),
          Text(
            value,
            style: isLgbtMode
                ? GoogleFonts.fredoka(
                    color: AppColors.hotPink,
                    fontWeight: FontWeight.w700,
                  )
                : GoogleFonts.inter(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ],
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  final int rank;
  final CityWealth city;
  final bool isLgbtMode;
  const _CityRow({required this.rank, required this.city, required this.isLgbtMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isLgbtMode ? 18 : 12),
        boxShadow: isLgbtMode
            ? AppShadow.soft
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
        border: Border.all(
          color: isLgbtMode ? AppColors.line : const Color(0xFFCBD5E1),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isLgbtMode ? AppColors.electricPurple.withOpacity(0.12) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(isLgbtMode ? 10 : 6),
            ),
            child: Center(
              child: Text(
                '#$rank',
                style: isLgbtMode
                    ? GoogleFonts.fredoka(
                        fontWeight: FontWeight.w700,
                        color: AppColors.electricPurple,
                        fontSize: 13,
                      )
                    : GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
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
                  style: isLgbtMode
                      ? GoogleFonts.fredoka(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.5,
                          color: AppColors.ink,
                        )
                      : GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                ),
                Text(
                  city.vibe,
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₱${city.avgSavings.toStringAsFixed(0)}',
            style: isLgbtMode
                ? GoogleFonts.fredoka(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.hotPink,
                  )
                : GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black,
                  ),
          ),
        ],
      ),
    );
  }
}
