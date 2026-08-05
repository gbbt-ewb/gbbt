import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';

class TransferScreen extends StatefulWidget {
  final UserModel user;

  const TransferScreen({
    super.key,
    required this.user,
  });

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

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Text(
          _fee == 0
              ? '✅ ₱${_amount.toStringAsFixed(2)} sent to ${_recipientController.text}\nPurpose: ${_selectedPurpose ?? "Personal Transfer"}\nFee waived 🌈'
              : '✅ ₱${_amount.toStringAsFixed(2)} sent to ${_recipientController.text}\nFee: ₱${_fee.toStringAsFixed(2)}',
        ),
      ),
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
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        foregroundColor: AppColors.ink,
        title: const Text('Bank Transfer'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.lavender.withOpacity(.25),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.user.isLgbtqia
                              ? "You're getting free transfers, always. 🌈"
                              : "Standard transfer fee: ₱15.00",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Text(
                  'Quick Contact',
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedContact,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.people_outline),
                    hintText: 'Select from contacts',
                  ),
                  items: _contacts
                      .map(
                        (contact) => DropdownMenuItem(
                          value: contact,
                          child: Text(contact),
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

                Text(
                  'Recipient',
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _recipientController,
                  decoration: const InputDecoration(
                    hintText: '@username or account number',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Recipient is required';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                Text(
                  'Purpose',
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  value: _selectedPurpose,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.description_outlined),
                    hintText: 'Select purpose',
                  ),
                  items: _purposes
                      .map(
                        (purpose) => DropdownMenuItem(
                          value: purpose,
                          child: Text(purpose),
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

                Text(
                  'Amount',
                  style: Theme.of(context).textTheme.labelLarge,
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.attach_money),
                    hintText: '0.00',
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

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      _summaryRow(
                        'Amount',
                        '₱${_amount.toStringAsFixed(2)}',
                      ),
                      const SizedBox(height: 8),
                      _summaryRow(
                        'Transfer Fee',
                        '₱${_fee.toStringAsFixed(2)}',
                      ),
                      const Divider(height: 24),
                      _summaryRow(
                        'Total',
                        '₱${_total.toStringAsFixed(2)}',
                        bold: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                GradientButton(
                  label: 'Send Money',
                  isLoading: _isLoading,
                  onPressed: _handleTransfer,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    bool bold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}