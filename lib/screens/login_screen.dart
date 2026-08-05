import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
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
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final user = UserModel(
      firstName: 'Divine',
      lastName: 'Cruz',
      email: 'divine.cruz@gbbtbank.fun',
      phone: '09171234567',
      dateOfBirth: DateTime(1998, 5, 10),
      gender: 'Bakla',
      taxBracket: 'Bracket B · Rising Glamour 👑',
      savings: 76500,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Text('🌈', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Welcome back, ${user.firstName}! Ready to slay? 💅',
                style: GoogleFonts.fredoka(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BonggaBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.ink),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 2,
                    ),
                  ),
                  const SizedBox(height: 12),

                  Center(
                    child: Column(
                      children: [
                        const RainbowMark(size: 72),
                        const SizedBox(height: 16),
                        const InteractiveSticker(text: '💅 SIGN IN BESTIE', rotateAngle: -0.05),
                        const SizedBox(height: 12),
                        const RainbowShimmerText(text: 'Welcome Back!', fontSize: 32),
                        const SizedBox(height: 4),
                        Text(
                          'Access your ultra fabulous GBBT vault ✨',
                          style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  BonggaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Username', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your fabulous handle',
                            prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.hotPink, size: 22),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Username is required, bestie!';
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
                            hintText: 'Enter secret passphrase',
                            prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.electricPurple, size: 22),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: AppColors.hotPink,
                                size: 22,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Password cannot be empty!';
                            if (value.length < 6) return 'Must be at least 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),
                        GradientButton(
                          label: 'Login to GBBT 👑',
                          icon: Icons.auto_awesome_rounded,
                          isLoading: _isLoading,
                          onPressed: _handleLogin,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(color: AppColors.ink, fontSize: 14.5),
                        children: [
                          const TextSpan(text: "Don't have an account yet? "),
                          TextSpan(
                            text: 'Create one now 💖',
                            style: GoogleFonts.fredoka(
                              color: AppColors.hotPink,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
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
      ),
    );
  }
}
