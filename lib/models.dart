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
  final double latitude;
  final double longitude;
  final String vibe;

  const CityWealth({
    required this.city,
    required this.avgSavings,
    required this.accountCount,
    required this.latitude,
    required this.longitude,
    required this.vibe,
  });
}
const mockCityWealth = [
  CityWealth(
    city: 'BGC',
    avgSavings: 620000,
    accountCount: 184,
    latitude: 14.5507,
    longitude: 121.0509,
    vibe: 'Certified Rich Zone 💎',
  ),
  CityWealth(
    city: 'Makati',
    avgSavings: 480000,
    accountCount: 210,
    latitude: 14.5547,
    longitude: 121.0244,
    vibe: 'Old Money Energy 👑',
  ),
  CityWealth(
    city: 'Quezon City',
    avgSavings: 210000,
    accountCount: 340,
    latitude: 14.6760,
    longitude: 121.0437,
    vibe: 'Comfortably Bongga 💅',
  ),
  CityWealth(
    city: 'Cebu',
    avgSavings: 175000,
    accountCount: 260,
    latitude: 10.3157,
    longitude: 123.8854,
    vibe: 'Rising Icon Zone ✨',
  ),
  CityWealth(
    city: 'Davao',
    avgSavings: 140000,
    accountCount: 190,
    latitude: 7.1907,
    longitude: 125.4553,
    vibe: 'Grinding Bestie Zone 💪',
  ),
  CityWealth(
    city: 'Baguio',
    avgSavings: 95000,
    accountCount: 120,
    latitude: 16.4023,
    longitude: 120.5960,
    vibe: 'Struggling Bestie Zone 🥲',
  ),
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
  final double pricePerShare;
  final double changePercent;
  final int auraScore;

  const AuraStock({
    required this.name,
    required this.tagline,
    required this.pricePerShare,
    required this.changePercent,
    required this.auraScore,
  });
}

const mockAuraStocks = [
  AuraStock(
    name: 'Andi',
    tagline: 'Latte-powered icon',
    pricePerShare: 125,
    changePercent: 8.4,
    auraScore: 96,
  ),
  AuraStock(
    name: 'Jamie',
    tagline: 'Spreadsheet royalty',
    pricePerShare: 98,
    changePercent: 5.2,
    auraScore: 91,
  ),
  AuraStock(
    name: 'Kai',
    tagline: 'Budgeting legend',
    pricePerShare: 86,
    changePercent: 3.8,
    auraScore: 88,
  ),
  AuraStock(
    name: 'Sam',
    tagline: 'Elite aura energy',
    pricePerShare: 220,
    changePercent: 12.3,
    auraScore: 99,
  ),
];

