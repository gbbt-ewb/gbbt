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
  final String taxBracket;
  final double savings;
  final String bio;

  const DatingProfile({
    required this.name,
    required this.age,
    required this.taxBracket,
    required this.savings,
    required this.bio,
  });
}

const mockDatingProfiles = [
  DatingProfile(name: 'Andi', age: 27, taxBracket: 'Bracket B · Rising', savings: 85000, bio: 'Loves oat milk lattes and long walks to the ATM.'),
  DatingProfile(name: 'Jamie', age: 30, taxBracket: 'Bracket C · Established', savings: 210000, bio: 'Spreadsheet enthusiast. Will split the bill exactly 50/50.'),
  DatingProfile(name: 'Reign', age: 24, taxBracket: 'Bracket A · Entry', savings: 12000, bio: 'Broke but the vibes are immaculate.'),
  DatingProfile(name: 'Kai', age: 29, taxBracket: 'Bracket B · Rising', savings: 92000, bio: 'Budgets in one tab, dreams in another.'),
  DatingProfile(name: 'Sam', age: 33, taxBracket: 'Bracket D · Elite', savings: 540000, bio: 'Will pay you back within the hour, no cap.'),
  DatingProfile(name: 'Blue', age: 26, taxBracket: 'Bracket A · Entry', savings: 15000, bio: 'Coupon collector. Certified thrift queen.'),
];
