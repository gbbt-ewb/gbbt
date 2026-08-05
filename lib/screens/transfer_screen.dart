import 'package:flutter/material.dart';
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(_fee == 0 ? 'Sent! Fee waived — being fabulous has its perks. 🌈' : 'Sent! ₱${_fee.toStringAsFixed(2)} fee applied.'),
      ),
    );
    _recipientController.clear();
    _amountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(backgroundColor: AppColors.cream, elevation: 0, title: const Text('Bank Transfer'), foregroundColor: AppColors.ink),
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
                  decoration: BoxDecoration(color: AppColors.lavender.withOpacity(0.25), borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: AppColors.primary, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.user.isLgbtqia ? "You're getting free transfers, always. 🌈" : 'Standard transfer fee: ₱15.00',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text('Recipient Account / Username', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _recipientController,
                  decoration: const InputDecoration(hintText: '@username or account number', prefixIcon: Icon(Icons.person_search_outlined, size: 20)),
                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Recipient is required' : null,
                ),
                const SizedBox(height: 20),
                Text('Amount', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(hintText: '0.00', prefixIcon: Icon(Icons.attach_money_rounded, size: 20)),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'Amount is required';
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                    return null;
                  },
                ),
                const SizedBox(height: 28),
                GradientButton(label: 'Send Money', isLoading: _isLoading, onPressed: _handleTransfer),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
