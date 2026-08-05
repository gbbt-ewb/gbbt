import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class TransferScreen extends StatefulWidget {
  final UserModel user;
  const TransferScreen({super.key, required this.user});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  bool _isLoading = false;

  double get _fee => widget.user.isLgbtqia ? 0 : 15;

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleTransfer() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.ink,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Text('💸', style: TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _fee == 0
                    ? 'Sent! ₱0 Fee Waived — LGBTQIA+ privilege activated! 🌈✨'
                    : 'Sent! ₱${_fee.toStringAsFixed(2)} fee applied. Stay fabulous!',
                style: GoogleFonts.fredoka(color: Colors.white, fontSize: 13.5),
              ),
            ),
          ],
        ),
      ),
    );
    _recipientController.clear();
    _amountController.clear();
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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.ink),
                        style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                      ),
                      const SizedBox(width: 12),
                      const RainbowShimmerText(text: 'Bank Transfer 💸', fontSize: 24),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Perk Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: electricRainbowGradient,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: AppShadow.soft,
                    ),
                    child: Row(
                      children: [
                        const Text('👑', style: TextStyle(fontSize: 26)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.user.isLgbtqia
                                ? "LGBTQIA+ Privilege: Free ₱0 Transfers Forever! 🌈"
                                : 'Standard transfer fee: ₱15.00 (Upgrade to Gay for free transfers 👀)',
                            style: GoogleFonts.fredoka(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Recipient Account', style: Theme.of(context).textTheme.labelLarge),
                            const InteractiveSticker(text: '💅 PAK!', rotateAngle: 0.05),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _recipientController,
                          decoration: const InputDecoration(
                            hintText: '@username or GBBT Vault ID',
                            prefixIcon: Icon(Icons.person_search_rounded, color: AppColors.hotPink, size: 22),
                          ),
                          validator: (value) => (value == null || value.trim().isEmpty) ? 'Recipient handle required!' : null,
                        ),
                        const SizedBox(height: 20),

                        Text('Amount (PHP)', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            hintText: '₱0.00',
                            prefixIcon: Icon(Icons.payments_rounded, color: AppColors.electricPurple, size: 22),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) return 'Enter an amount, bestie!';
                            final parsed = double.tryParse(value);
                            if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                            return null;
                          },
                        ),
                        const SizedBox(height: 28),

                        GradientButton(
                          label: 'Send Cash Now 💖',
                          icon: Icons.send_rounded,
                          isLoading: _isLoading,
                          onPressed: _handleTransfer,
                        ),
                      ],
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
