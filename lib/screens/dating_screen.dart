import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models.dart';

class DatingScreen extends StatelessWidget {
  final UserModel user;

  const DatingScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final matches = mockDatingProfiles
        .where((p) => p.taxBracket == user.taxBracket)
        .toList();

    final others = mockDatingProfiles
        .where((p) => p.taxBracket != user.taxBracket)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text("Money Match"),
        elevation: 0,
        backgroundColor: AppColors.cream,
        foregroundColor: AppColors.ink,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: rainbowGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Money Match 💘",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Matched by tax bracket and savings because finance is sexy.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.95),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (matches.isNotEmpty) ...[
              Text(
                "Your Matches (${user.taxBracket})",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              ...matches.map(
                (profile) => _ProfileCard(
                  profile: profile,
                  isMatch: true,
                ),
              ),

              const SizedBox(height: 24),
            ],

            Text(
              "Other Fabulous Singles",
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: 12),

            ...others.map(
              (profile) => _ProfileCard(
                profile: profile,
                isMatch: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final DatingProfile profile;
  final bool isMatch;

  const _ProfileCard({
    required this.profile,
    required this.isMatch,
  });

  int get compatibility {
    if (isMatch) {
      return 95;
    }
    return 68;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppShadow.soft,
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            decoration: const BoxDecoration(
              gradient: rainbowGradient,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 45,
                backgroundColor: Colors.white,
                child: Text(
                  profile.name[0],
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${profile.name}, ${profile.age}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    if (isMatch)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "💘 Match",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  profile.bio,
                  style: TextStyle(
                    color: AppColors.inkMuted,
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 15),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _chip(profile.taxBracket),
                    _chip(
                        "₱${profile.savings.toStringAsFixed(0)} Saved"),
                    _chip("Coffee"),
                    _chip("Travel"),
                    _chip("Investing"),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Compatibility",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "$compatibility%",
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: compatibility / 100,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isMatch
                          ? Colors.pink
                          : Colors.orange,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text("Pass"),
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                              const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                "You passed on ${profile.name}",
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.favorite),
                        label: const Text("Like"),
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size.fromHeight(46),
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            SnackBar(
                              content: Text(
                                "You liked ${profile.name}! ❤️",
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}