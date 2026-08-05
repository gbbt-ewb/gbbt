import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'create_account_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late final TapGestureRecognizer _createAccountTap = TapGestureRecognizer()
    ..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CreateAccountScreen()));

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _createAccountTap.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulated auth call
    if (!mounted) return;
    setState(() => _isLoading = false);

    // Demo/mock user for the login path — any correctly-formatted
    // credentials "succeed" since there's no real backend here.
    final user = UserModel(
      firstName: 'Divine',
      lastName: 'Cruz',
      email: 'divine.cruz@gbbtbank.fun',
      phone: '09171234567',
      dateOfBirth: DateTime(1998, 5, 10),
      gender: 'Bakla',
      taxBracket: 'Bracket B · Rising',
      savings: 76500,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text('Welcome back, ${user.firstName}! 🌈'),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                  style: IconButton.styleFrom(alignment: Alignment.centerLeft),
                ),
                const SizedBox(height: 8),
                const RainbowMark(size: 56),
                const SizedBox(height: 20),
                Text('Welcome back, bestie', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 6),
                Text('Sign in to your fabulous account', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.inkMuted)),
                const SizedBox(height: 32),
                Text('Username', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(hintText: 'Enter your username', prefixIcon: Icon(Icons.person_outline, size: 20)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Username is required';
                    if (value.trim().length < 3) return 'Must be at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Text('Password', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Password is required';
                    if (value.length < 6) return 'Must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                GradientButton(label: 'Login', isLoading: _isLoading, onPressed: _handleLogin),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Create one',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
                          recognizer: _createAccountTap,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
