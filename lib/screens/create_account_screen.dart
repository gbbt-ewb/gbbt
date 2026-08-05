import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

Future<bool> _showTermsDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Text('📜', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Terms & Conditions 💖',
              style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 20),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Text(
          'Welcome to GBBT Bank! Before you proceed, please note:\n\n'
          '1. By creating an account, you agree that any money deposited '
          'legally, morally, and spiritually belongs to GBBT Bank now. '
          "Just kidding. (...Unless? 👀)\n\n"
          '2. This app is a parody built for fun and does not process real '
          'money, transfers, or personal data.\n\n'
          '3. Free transfers for our LGBTQIA+ family, always. 🌈\n\n'
          '4. No refunds on sass.\n\n'
          'By tapping "I Agree", you confirm you have a sense of humor and are 100% fabulous.',
          style: GoogleFonts.inter(fontSize: 14, height: 1.5, color: AppColors.ink),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Cancel', style: GoogleFonts.fredoka(color: AppColors.inkMuted)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.hotPink,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('I Agree 💅', style: GoogleFonts.fredoka(fontWeight: FontWeight.w600)),
        ),
      ],
    ),
  );
  return result ?? false;
}

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  final _customGenderController = TextEditingController();
  DateTime? _selectedDob;
  String? _selectedGender;
  bool _agreedToTerms = false;
  bool _isLoading = false;

  late final TapGestureRecognizer _signInTap = TapGestureRecognizer()
    ..onTap = () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
  late final TapGestureRecognizer _viewTermsTap = TapGestureRecognizer()..onTap = () => _showTermsDialog(context);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _customGenderController.dispose();
    _signInTap.dispose();
    _viewTermsTap.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final now = DateTime.now();
    final eighteenYearsAgo = DateTime.now().subtract(const Duration(days: 365 * 18));
    final picked = await showDatePicker(
      context: context,
      initialDate: eighteenYearsAgo,
      firstDate: DateTime(now.year - 100),
      lastDate: eighteenYearsAgo,
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _selectedDob = picked;
        _dobController.text = '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birthday, bestie! 🎉')),
      );
      return;
    }
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your gender identity 🌈')),
      );
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to our fab Terms & Conditions!')),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    final nameParts = _nameController.text.trim().split(RegExp(r'\s+'));
    final resolvedGender = _selectedGender == 'Other' && _customGenderController.text.trim().isNotEmpty
        ? _customGenderController.text.trim()
        : _selectedGender!;

    final newUser = UserModel(
      firstName: nameParts.first,
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      dateOfBirth: _selectedDob!,
      gender: resolvedGender,
      taxBracket: taxBrackets.first,
      savings: 10000,
    );

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(gradient: electricRainbowGradient, shape: BoxShape.circle),
              child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 38),
            ),
            const SizedBox(height: 18),
            Text(
              'YASSS! Welcome to GBBT! 🎉',
              style: GoogleFonts.fredoka(color: AppColors.ink, fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your account has been activated, ${newUser.firstName}. Starter bonus of ₱10,000 added to your vault! 💸',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 14),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.hotPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Enter GBBT Vault ✨', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => DashboardScreen(user: newUser)));
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
                    style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                  ),
                  const SizedBox(height: 8),

                  Center(
                    child: Column(
                      children: [
                        const RainbowMark(size: 72),
                        const SizedBox(height: 14),
                        const InteractiveSticker(text: '✨ JOIN THE FAM', rotateAngle: -0.06),
                        const SizedBox(height: 10),
                        const RainbowShimmerText(text: 'Create Account', fontSize: 32),
                        const SizedBox(height: 4),
                        Text(
                          'Fill in your details to start your fabulous journey ✨',
                          style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 13.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  BonggaCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Full Name', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            hintText: 'Juan Dela Cruz',
                            prefixIcon: Icon(Icons.badge_outlined, color: AppColors.hotPink, size: 22),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Full name is required';
                            if (value.trim().length < 3) return 'Must be at least 3 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        Text('Phone Number', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          maxLength: 11,
                          decoration: const InputDecoration(
                            hintText: '09171234567',
                            prefixIcon: Icon(Icons.phone_outlined, color: AppColors.electricPurple, size: 22),
                            counterText: '',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Phone number is required';
                            if (value.length != 11) return 'Must be exactly 11 digits';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        Text('Email Address', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            hintText: 'you@fabulous.com',
                            prefixIcon: Icon(Icons.email_outlined, color: AppColors.cyanSparkle, size: 22),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Email is required';
                            if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email address';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        Text('Date of Birth', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _dobController,
                          readOnly: true,
                          onTap: _pickDateOfBirth,
                          decoration: const InputDecoration(
                            hintText: 'MM/DD/YYYY',
                            prefixIcon: Icon(Icons.cake_outlined, color: AppColors.neonGold, size: 22),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Date of birth is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),

                        Text('Gender Identity', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.diversity_3_outlined, color: AppColors.hotPink, size: 22),
                          ),
                          hint: const Text('Select your gender'),
                          items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                          onChanged: (value) => setState(() => _selectedGender = value),
                          validator: (value) => value == null ? 'Please select your gender' : null,
                        ),
                        if (_selectedGender == 'Other') ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _customGenderController,
                            decoration: const InputDecoration(hintText: 'Tell us how you identify ✨'),
                            validator: (value) {
                              if (_selectedGender == 'Other' && (value == null || value.trim().isEmpty)) {
                                return 'Please tell us how you identify';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 20),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _agreedToTerms,
                              activeColor: AppColors.hotPink,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                              onChanged: (value) async {
                                if (value == true) {
                                  final agreed = await _showTermsDialog(context);
                                  if (!mounted) return;
                                  setState(() => _agreedToTerms = agreed);
                                } else {
                                  setState(() => _agreedToTerms = false);
                                }
                              },
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.inter(color: AppColors.ink, fontSize: 13.5),
                                    children: [
                                      const TextSpan(text: 'I agree to the '),
                                      TextSpan(
                                        text: 'Terms & Conditions',
                                        style: GoogleFonts.fredoka(color: AppColors.hotPink, fontWeight: FontWeight.w700),
                                        recognizer: _viewTermsTap,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        GradientButton(
                          label: 'Create Account 💖',
                          icon: Icons.rocket_launch_rounded,
                          isLoading: _isLoading,
                          onPressed: _agreedToTerms ? _handleSubmit : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(color: AppColors.ink, fontSize: 14),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In Bestie',
                            style: GoogleFonts.fredoka(color: AppColors.hotPink, fontWeight: FontWeight.w700),
                            recognizer: _signInTap,
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
