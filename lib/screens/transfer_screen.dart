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

  final List<String> _contacts = [
    '🌈 Alex Santos',
    '💖 Jamie Cruz',
    '✨ Taylor Lim',
    '🦄 Morgan Reyes',
    '⭐ Sam Garcia',
  ];

  final List<String> _purposes = [
    'Personal Transfer',
    'Bills Payment',
    'Allowance',
    'Food & Dining',
    'Shopping',
    'Emergency Fund',
    'Gift',
    'Travel',
  ];

  String? _selectedContact;
  String? _selectedPurpose;

  double get _fee => widget.user.isLgbtqia ? 0 : 15;

  @override
  void dispose() {
    _recipientController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  double get _amount {
    return double.tryParse(_amountController.text) ?? 0;
  }

  double get _total {
    return _amount + _fee;
  }

  Future<void> _handleTransfer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isLoading = false);

    // Trigger OA Explosive Cash Popup!
    await showOaSuccessDialog(
      context,
      title: 'SEND CASH SUCCESS! 💸💥',
      subtitle: 'Your money has arrived safely in style & glamour! ✨💅',
      amount: _amount,
      recipient: _recipientController.text,
      purpose: _selectedPurpose ?? 'Personal Transfer',
      fee: _fee,
    );

    _recipientController.clear();
    _amountController.clear();

    setState(() {
      _selectedContact = null;
      _selectedPurpose = null;
    });
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
                                : "Standard transfer fee: ₱15.00 (Upgrade to Gay for free transfers 👀)",
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
                        Text('Quick Contact', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedContact,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.people_outline_rounded, color: AppColors.hotPink, size: 22),
                            hintText: 'Select from contacts',
                          ),
                          items: _contacts
                              .map(
                                (contact) => DropdownMenuItem(
                                  value: contact,
                                  child: Text(contact, style: GoogleFonts.fredoka(fontSize: 14)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedContact = value;
                              if (value != null) {
                                _recipientController.text = value;
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 20),

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
                            hintText: '@username or account number',
                            prefixIcon: Icon(Icons.person_search_rounded, color: AppColors.electricPurple, size: 22),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Recipient handle required!';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        Text('Purpose', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedPurpose,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.description_outlined, color: AppColors.cyanSparkle, size: 22),
                            hintText: 'Select purpose',
                          ),
                          items: _purposes
                              .map(
                                (purpose) => DropdownMenuItem(
                                  value: purpose,
                                  child: Text(purpose, style: GoogleFonts.fredoka(fontSize: 14)),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPurpose = value;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a purpose';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        Text('Amount (PHP)', style: Theme.of(context).textTheme.labelLarge),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: '₱0.00',
                            prefixIcon: Icon(Icons.payments_rounded, color: AppColors.neonGold, size: 22),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Amount is required';
                            }
                            final amount = double.tryParse(value);
                            if (amount == null || amount <= 0) {
                              return 'Enter a valid amount';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // SUMMARY CALCULATION BOX
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.9),
                            border: Border.all(color: AppColors.line, width: 1.5),
                          ),
                          child: Column(
                            children: [
                              _summaryRow('Amount', '₱${_amount.toStringAsFixed(2)}'),
                              const SizedBox(height: 8),
                              _summaryRow('Transfer Fee', '₱${_fee.toStringAsFixed(2)}'),
                              const Divider(height: 24, color: AppColors.line),
                              _summaryRow('Total', '₱${_total.toStringAsFixed(2)}', bold: true),
                            ],
                          ),
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

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            fontSize: bold ? 16 : 14,
            color: bold ? AppColors.hotPink : AppColors.ink,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            fontSize: bold ? 16 : 14,
            color: bold ? AppColors.hotPink : AppColors.ink,
          ),
        ),
      ],
    );
  }
}
