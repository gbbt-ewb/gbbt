import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

Future<bool> _showTermsDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: const Text('Terms & Conditions 📜'),
      content: const SingleChildScrollView(
        child: Text(
          'Welcome to GBBT Bank! Before you proceed, please note:\n\n'
          '1. By creating an account, you agree that any money deposited '
          'legally, morally, and spiritually belongs to GBBT Bank now. '
          "Just kidding. (...Unless? 👀)\n\n"
          '2. This app is a parody built for fun and does not process real '
          'money, transfers, or personal data.\n\n'
          '3. Free transfers for our LGBTQIA+ family, always. 🌈\n\n'
          '4. No refunds on sass.\n\n'
          'By tapping "I Agree", you confirm you have a sense of humor.',
          style: TextStyle(height: 1.5),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('I Agree'),
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
    // initialDate is set to the same value as lastDate so it can never
    // accidentally fall after it (which would crash showDatePicker).
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select your date of birth')));
      return;
    }
    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select your gender')));
      return;
    }
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to the Terms & Conditions')));
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // simulated account creation
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
      taxBracket: taxBrackets.first, // new accounts start at entry level
      savings: 0,
    );

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(gradient: rainbowGradient, shape: BoxShape.circle),
              child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 32),
            ),
            const SizedBox(height: 18),
            Text('Yasss, welcome to GBBT Bank!', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              'Your account has been created, ${newUser.firstName}. 🌈',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.inkMuted),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.w700)),
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
                const Center(child: RainbowMark(size: 72)),
                const SizedBox(height: 20),
                Text('Join the fam', style: Theme.of(context).textTheme.displaySmall, textAlign: TextAlign.center),
                const SizedBox(height: 6),
                Text(
                  'Create your GBBT Bank account',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.inkMuted),
                ),
                const SizedBox(height: 28),

                Text('Full Name', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'Juan Dela Cruz', prefixIcon: Icon(Icons.badge_outlined, size: 20)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Full name is required';
                    if (value.trim().length < 3) return 'Must be at least 3 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Text('Phone Number', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  maxLength: 11,
                  decoration: const InputDecoration(hintText: '09171234567', prefixIcon: Icon(Icons.phone_outlined, size: 20), counterText: ''),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Phone number is required';
                    if (value.length != 11) return 'Must be exactly 11 digits';
                    return null;
                  },
                ),
                const SizedBox(height: 4),

                Text('Email Address', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(hintText: 'you@email.com', prefixIcon: Icon(Icons.email_outlined, size: 20)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Email is required';
                    if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email address';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Text('Date of Birth', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _pickDateOfBirth,
                  decoration: const InputDecoration(hintText: 'MM/DD/YYYY', prefixIcon: Icon(Icons.cake_outlined, size: 20)),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Date of birth is required';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                Text('Gender', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.diversity_3_outlined, size: 20)),
                  hint: const Text('Select your gender'),
                  items: genderOptions.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (value) => setState(() => _selectedGender = value),
                  validator: (value) => value == null ? 'Please select your gender' : null,
                ),
                if (_selectedGender == 'Other') ...[
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _customGenderController,
                    decoration: const InputDecoration(hintText: 'Tell us how you identify'),
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
                      activeColor: AppColors.primary,
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
                        padding: const EdgeInsets.only(top: 14),
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium,
                            children: [
                              const TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms & Conditions',
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
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
                  label: 'Submit',
                  isLoading: _isLoading,
                  onPressed: _agreedToTerms ? _handleSubmit : null,
                ),
                const SizedBox(height: 20),
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Sign In',
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700),
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
    );
  }
}
