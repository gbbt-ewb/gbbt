import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const GbbtBankApp());
}

class GbbtBankApp extends StatelessWidget {
  const GbbtBankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GBBT Bank',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const WelcomeScreen(),
    );
  }
}
