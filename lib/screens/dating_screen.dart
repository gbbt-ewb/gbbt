import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models.dart';

class DatingScreen extends StatelessWidget {
  final UserModel user;
  const DatingScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final matches = mockDatingProfiles.where((p) => p.taxBracket == user.taxBracket).toList();
    final others = mockDatingProfiles.where((p) => p.taxBracket != user.taxBracket).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(backgroundColor: AppColors.cream, elevation: 0, title: const Text('Money Match'), foregroundColor: AppColors.ink),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              'Matched by tax bracket & savings — because love is a numbers game. 💘',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.inkMuted),
            ),
            const SizedBox(height: 20),
            if (matches.isNotEmpty) ...[
              Text('Your Matches (${user.taxBracket})', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              ...matches.map((p) => _ProfileCard(profile: p, isMatch: true)),
              const SizedBox(height: 24),
            ],
            Text('Other Fabulous Singles', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...others.map((p) => _ProfileCard(profile: p, isMatch: false)),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final DatingProfile profile;
  final bool isMatch;
  const _ProfileCard({required this.profile, required this.isMatch});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: AppShadow.soft),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(gradient: rainbowGradient, shape: BoxShape.circle),
            child: Center(child: Text(profile.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('${profile.name}, ${profile.age}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                    if (isMatch) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                        child: const Text('Match 💘', style: TextStyle(color: AppColors.primary, fontSize: 10.5, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(profile.bio, style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted)),
                const SizedBox(height: 4),
                Text(
                  '${profile.taxBracket} · ₱${profile.savings.toStringAsFixed(0)} saved',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
