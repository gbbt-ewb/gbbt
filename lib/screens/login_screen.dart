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
    
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen(user: user)));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppModeController.instance,
      builder: (context, isLgbtMode, _) {
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
                        icon: Icon(Icons.arrow_back_ios_new, size: 20, color: isLgbtMode ? AppColors.ink : Colors.black),
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
                            InteractiveSticker(
                              text: isLgbtMode ? '💅 SIGN IN BESTIE' : 'SIGN IN',
                              rotateAngle: isLgbtMode ? -0.05 : 0.0,
                            ),
                            const SizedBox(height: 12),
                            const RainbowShimmerText(text: 'Welcome Back!', fontSize: 32),
                            const SizedBox(height: 4),
                            Text(
                              isLgbtMode ? 'Access your ultra fabulous GBBT vault ✨' : 'Access your GBBT account',
                              style: GoogleFonts.inter(
                                color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      BonggaCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: isLgbtMode
                                  ? GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)
                                  : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: isLgbtMode ? 'Enter your fabulous handle' : 'Enter your username',
                                prefixIcon: Icon(Icons.person_outline_rounded, color: isLgbtMode ? AppColors.hotPink : Colors.black, size: 22),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) return 'Username is required!';
                                if (value.trim().length < 3) return 'Must be at least 3 characters';
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            Text(
                              'Password',
                              style: isLgbtMode
                                  ? GoogleFonts.fredoka(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.ink)
                                  : GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Enter secret passphrase',
                                prefixIcon: Icon(Icons.lock_outline_rounded, color: isLgbtMode ? AppColors.electricPurple : Colors.black, size: 22),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                    color: isLgbtMode ? AppColors.hotPink : Colors.black,
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
                          
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  final forgotPassFormKey = GlobalKey<FormState>();
                                  final newPassController = TextEditingController();
                                  final confirmPassController = TextEditingController();

                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(isLgbtMode ? 20 : 12),
                                      ),
                                      title: Text('Forgot Password 🔐', style: isLgbtMode ? GoogleFonts.fredoka() : GoogleFonts.inter()),
                                      content: Form(
                                        key: forgotPassFormKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: newPassController,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                labelText: 'New Password',
                                                prefixIcon: Icon(Icons.lock_outline),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) return 'Password is required';
                                                if (value.length < 6) return 'Must be at least 6 characters';
                                                return null;
                                              },
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormField(
                                              controller: confirmPassController,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                labelText: 'Confirm New Password',
                                                prefixIcon: Icon(Icons.verified_user_outlined),
                                              ),
                                              validator: (value) {
                                                if (value == null || value.isEmpty) return 'Please confirm password';
                                                if (value != newPassController.text) return 'Passwords do not match';
                                                return null;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel', style: TextStyle(color: isLgbtMode ? AppColors.hotPink : Colors.black)),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isLgbtMode ? AppColors.hotPink : Colors.black,
                                            foregroundColor: Colors.white,
                                          ),
                                          onPressed: () {
                                            if (forgotPassFormKey.currentState!.validate()) {
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  behavior: SnackBarBehavior.floating,
                                                  backgroundColor: isLgbtMode ? AppColors.ink : Colors.black,
                                                  content: Text(
                                                    'Password reset successfully! 🔐',
                                                    style: isLgbtMode ? GoogleFonts.fredoka() : GoogleFonts.inter(),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: const Text('Reset Password'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: isLgbtMode
                                      ? GoogleFonts.fredoka(color: AppColors.hotPink, fontWeight: FontWeight.w600)
                                      : GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            GradientButton(
                              label: isLgbtMode ? 'Sign In Now ✨' : 'Sign In',
                              icon: Icons.login_rounded,
                              isLoading: _isLoading,
                              onPressed: _handleLogin,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.inter(color: isLgbtMode ? AppColors.inkMuted : Colors.grey[700], fontSize: 14),
                            children: [
                              const TextSpan(text: "Don't have an account yet? "),
                              TextSpan(
                                recognizer: _createAccountTap,
                                text: isLgbtMode ? 'Join the Glamour 💅' : 'Create Account',
                                style: isLgbtMode
                                    ? GoogleFonts.fredoka(color: AppColors.hotPink, fontWeight: FontWeight.w700)
                                    : GoogleFonts.inter(color: Colors.black, fontWeight: FontWeight.w700),
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
      },
    );
  }
}
