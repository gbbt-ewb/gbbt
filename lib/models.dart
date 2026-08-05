import 'package:flutter/foundation.dart';

const genderOptions = [
  'Woman',
  'Man',
  'Non-binary',
  'Transgender Woman',
  'Transgender Man',
  'Bakla',
  'Tomboy',
  'Genderfluid',
  'Genderqueer',
  'Prefer not to say',
  'Other',
];

// Used to decide free-transfer eligibility on the Bank Transfer screen.
const lgbtqiaGenders = {
  'Non-binary',
  'Transgender Woman',
  'Transgender Man',
  'Bakla',
  'Tomboy',
  'Genderfluid',
  'Genderqueer',
};

const taxBrackets = [
  'Bracket A · Entry',
  'Bracket B · Rising',
  'Bracket C · Established',
  'Bracket D · Elite',
];

@immutable
class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final DateTime dateOfBirth;
  final String gender;
  final String taxBracket;
  final double savings;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.taxBracket,
    required this.savings,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';
  bool get isLgbtqia => lgbtqiaGenders.contains(gender);
}

@immutable
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  const ChatMessage({required this.text, required this.isUser,required this.timestamp,});
}

@immutable
class DatingProfile {
  final String name;
  final int age;
  final String bio;
  final String taxBracket;
  final double savings;

  final String? location;
  final bool verified;
  final List<String> interests;

  const DatingProfile({
    required this.name,
    required this.age,
    required this.bio,
    required this.taxBracket,
    required this.savings,

    this.location,
    this.verified = false,
    this.interests = const [],
  });
}

const mockDatingProfiles = [
  DatingProfile(
    name: 'Andi',
    age: 27,
    taxBracket: 'Bracket B · Rising',
    savings: 85000,
    bio: 'Loves oat milk lattes and long walks to the ATM.',
    location: 'Manila',
    verified: true,
    interests: [
      'Coffee',
      'Travel',
      'Investing',
    ],
  ),

  DatingProfile(
    name: 'Jamie',
    age: 30,
    taxBracket: 'Bracket C · Established',
    savings: 210000,
    bio: 'Spreadsheet enthusiast. Will split the bill exactly 50/50.',
    location: 'Quezon City',
    verified: true,
    interests: [
      'Stocks',
      'Fitness',
      'Food',
    ],
  ),

  DatingProfile(
    name: 'Reign',
    age: 24,
    taxBracket: 'Bracket A · Entry',
    savings: 12000,
    bio: 'Broke but the vibes are immaculate.',
    location: 'Cebu',
    verified: false,
    interests: [
      'Music',
      'Gaming',
      'Coffee',
    ],
  ),

  DatingProfile(
    name: 'Kai',
    age: 29,
    taxBracket: 'Bracket B · Rising',
    savings: 92000,
    bio: 'Budgets in one tab, dreams in another.',
    location: 'Makati',
    verified: true,
    interests: [
      'Business',
      'Travel',
      'Investing',
    ],
  ),

  DatingProfile(
    name: 'Sam',
    age: 33,
    taxBracket: 'Bracket D · Elite',
    savings: 540000,
    bio: 'Will pay you back within the hour, no cap.',
    location: 'BGC',
    verified: true,
    interests: [
      'Luxury',
      'Finance',
      'Food',
    ],
  ),

  DatingProfile(
    name: 'Blue',
    age: 26,
    taxBracket: 'Bracket A · Entry',
    savings: 15000,
    bio: 'Coupon collector. Certified thrift queen.',
    location: 'Davao',
    verified: false,
    interests: [
      'Shopping',
      'Coffee',
      'Movies',
    ],
  ),
];

// ═══════════════════════════════════════════════════════════
// BROKEFINDER — city-level AGGREGATE wealth data only.
// Deliberately no per-user pins or coordinates: showing exactly
// which individual has how much money, tied to a location, is a
// real safety risk (it's the same combination used for targeting
// wealthy people), so this stays at the city-aggregate level.
// lat/lng below are normalized 0–1 positions for a stylized map
// illustration, not real-world geographic coordinates.
// ═══════════════════════════════════════════════════════════
@immutable
class CityWealth {
  final String city;
  final double avgSavings;
  final int accountCount;
  final double mapX;
  final double mapY;
  final String vibe;

  const CityWealth({
    required this.city,
    required this.avgSavings,
    required this.accountCount,
    required this.mapX,
    required this.mapY,
    required this.vibe,
  });
}

const mockCityWealth = [
  CityWealth(city: 'BGC', avgSavings: 620000, accountCount: 184, mapX: 0.62, mapY: 0.55, vibe: 'Certified Rich Zone 💎'),
  CityWealth(city: 'Makati', avgSavings: 480000, accountCount: 210, mapX: 0.56, mapY: 0.50, vibe: 'Old Money Energy 👑'),
  CityWealth(city: 'Quezon City', avgSavings: 210000, accountCount: 340, mapX: 0.38, mapY: 0.46, vibe: 'Comfortably Bongga 💅'),
  CityWealth(city: 'Cebu', avgSavings: 175000, accountCount: 260, mapX: 0.70, mapY: 0.30, vibe: 'Rising Icon Zone ✨'),
  CityWealth(city: 'Davao', avgSavings: 140000, accountCount: 190, mapX: 0.84, mapY: 0.42, vibe: 'Grinding Bestie Zone 💪'),
  CityWealth(city: 'Baguio', avgSavings: 95000, accountCount: 120, mapX: 0.22, mapY: 0.34, vibe: 'Struggling Bestie Zone 🥲'),
];

// ═══════════════════════════════════════════════════════════
// AURA EXCHANGE — a meme-stock market for personality, not
// appearance. Deliberately NOT connected to Vibe Check or any
// camera/photo — the "Aura Score" is derived from playful app
// engagement stats (streaks, chat sass, transactions) so nobody's
// worth is tied to how they look.
// ═══════════════════════════════════════════════════════════
@immutable
class AuraStock {
  final String name;
  final String tagline;
  final int auraScore;
  final double pricePerShare;
  final double changePercent;

  const AuraStock({
    required this.name,
    required this.tagline,
    required this.auraScore,
    required this.pricePerShare,
    required this.changePercent,
  });
}

const mockAuraStocks = [
  AuraStock(name: 'Divine C.', tagline: 'Comeback queen energy · 47-day login streak 🔥', auraScore: 88, pricePerShare: 42.50, changePercent: 5.2),
  AuraStock(name: 'Andi S.', tagline: 'Chaotic good vibes · Top chatbot roaster 🌈', auraScore: 76, pricePerShare: 31.10, changePercent: -1.4),
  AuraStock(name: 'Jamie C.', tagline: 'Spreadsheet royalty · Never missed a bill 👑', auraScore: 91, pricePerShare: 58.00, changePercent: 8.9),
  AuraStock(name: 'Kai R.', tagline: 'Soft launch legend · Quietly maxing savings ✨', auraScore: 82, pricePerShare: 39.75, changePercent: 2.1),
  AuraStock(name: 'Reign T.', tagline: 'Certified bestie material · Referred 12 friends 💖', auraScore: 70, pricePerShare: 24.30, changePercent: -3.0),
];