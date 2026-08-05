import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../app_theme.dart';
import '../models.dart';
import '../shared_widgets.dart';
import 'dashboard_screen.dart';

class JourneyScreen extends StatefulWidget {
  const JourneyScreen({super.key});

  @override
  State<JourneyScreen> createState() => _JourneyScreenState();
}

class _JourneyScreenState extends State<JourneyScreen> {
  Map<String, dynamic>? journey;
  int currentStepIndex = 0;
  final Map<String, dynamic> answers = {};
  final Map<String, TextEditingController> controllers = {};
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadJourney();
  }

  Future<void> loadJourney() async {
    final raw = await rootBundle.loadString('lib/journeys/gbbt_onboarding.json');
    setState(() {
      journey = jsonDecode(raw);
    });
  }

  @override
  void dispose() {
    for (final controller in controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController getController(String fieldId) {
    if (!controllers.containsKey(fieldId)) {
      controllers[fieldId] = TextEditingController();
    }
    return controllers[fieldId]!;
  }

  List<dynamic> get steps => journey!['steps'];

  void nextStep() {
    if (currentStepIndex < steps.length - 1) {
      setState(() {
        currentStepIndex++;
      });
    }
  }

  void previousStep() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    }
  }

  Future<void> selectDate(String fieldId) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );

    if (pickedDate == null) return;

    final formatted = '${pickedDate.month}/${pickedDate.day}/${pickedDate.year}';

    setState(() {
      answers[fieldId] = formatted;
      getController(fieldId).text = formatted;
    });
  }

  Widget buildField(Map<String, dynamic> field) {
    final fieldId = field["fieldId"];
    final type = field["type"];

    if (field.containsKey("visibleWhen")) {
      final visibleWhen = field["visibleWhen"];
      if (answers[visibleWhen["field"]] != visibleWhen["equals"]) {
        return const SizedBox();
      }
    }

    IconData icon = Icons.edit_note_rounded;

    switch (fieldId) {
      case "fullName":
        icon = Icons.badge_outlined;
        break;
      case "phoneNumber":
        icon = Icons.phone_outlined;
        break;
      case "emailAddress":
        icon = Icons.email_outlined;
        break;
      case "dateOfBirth":
        icon = Icons.cake_outlined;
        break;
      case "gender":
        icon = Icons.diversity_3_outlined;
        break;
    }

    switch (type) {
      case "text":
      case "email":
      case "phone":
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field["label"], style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: getController(fieldId),
                keyboardType: type == "email"
                    ? TextInputType.emailAddress
                    : type == "phone"
                        ? TextInputType.phone
                        : TextInputType.text,
                inputFormatters: type == "phone"
                    ? [FilteringTextInputFormatter.digitsOnly]
                    : null,
                decoration: InputDecoration(
                  hintText: type == "phone" ? "09171234567" : field["hint"],
                  prefixIcon: Icon(icon, color: AppColors.hotPink, size: 22),
                  prefixText: type == "phone" ? "+63 " : null,
                  prefixStyle: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '${field["label"]} is required';
                  }
                  if (fieldId == "fullName" && value.trim().length < 3) {
                    return 'Minimum 3 characters required';
                  }
                  if (type == "email") {
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid email address';
                    }
                  }
                  if (type == "phone") {
                    if (value.length != 10 && value.length != 11) {
                      return 'Enter a valid 10 or 11 digit number';
                    }
                  }
                  return null;
                },
                onChanged: (value) {
                  if (type == "phone") {
                    answers[fieldId] = "+63 $value";
                  } else {
                    answers[fieldId] = value;
                  }
                },
              ),
            ],
          ),
        );

      case "date":
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field["label"], style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              TextFormField(
                controller: getController(fieldId),
                readOnly: true,
                onTap: () => selectDate(fieldId),
                decoration: InputDecoration(
                  hintText: field["hint"] ?? "MM/DD/YYYY",
                  prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.neonGold, size: 22),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Date of Birth is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        );

      case "dropdown":
        return Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(field["label"], style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.diversity_3_outlined, color: AppColors.electricPurple, size: 22),
                ),
                hint: Text('Select ${field["label"]}'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '${field["label"]} is required';
                  }
                  return null;
                },
                items: (field["options"] as List)
                    .map(
                      (e) => DropdownMenuItem<String>(
                        value: e.toString(),
                        child: Text(e.toString(), style: GoogleFonts.fredoka(fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    answers[fieldId] = value;
                  });
                },
              ),
            ],
          ),
        );

      default:
        return const SizedBox();
    }
  }

  Widget buildFormStep(Map<String, dynamic> step) {
    final fields = step['fields'] as List;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: fields.map<Widget>((field) => buildField(field)).toList(),
            ),
          ),
          const SizedBox(height: 16),
          GradientButton(
            label: 'Continue ✨',
            icon: Icons.arrow_forward_rounded,
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (_formKey.currentState!.validate()) {
                nextStep();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildTermsStep(Map<String, dynamic> step) {
    bool accepted = answers['termsAccepted'] == true;

    return StatefulBuilder(
      builder: (context, setLocalState) {
        return Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.line, width: 1.5),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    step['content'],
                    style: GoogleFonts.inter(fontSize: 13.5, height: 1.55, color: AppColors.ink),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: accepted ? AppColors.hotPink : AppColors.line, width: 2),
              ),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(18),
                child: CheckboxListTile(
                  value: accepted,
                  activeColor: AppColors.hotPink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onChanged: (value) {
                    setLocalState(() {
                      accepted = value ?? false;
                    });
                    answers['termsAccepted'] = accepted;
                  },
                  title: Text(
                    'I Agree to the Terms & Conditions 💖',
                    style: GoogleFonts.fredoka(fontWeight: FontWeight.w600, color: AppColors.ink),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            GradientButton(
              label: 'Continue 🚀',
              icon: Icons.check_circle_rounded,
              onPressed: accepted ? nextStep : null,
            ),
          ],
        );
      },
    );
  }

  Widget buildAccountSelectionStep(Map<String, dynamic> step) {
    final accounts = step["accounts"] as List;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: accounts.length,
            itemBuilder: (context, index) {
              final account = accounts[index];
              final isSelected = answers["selectedAccount"] == account["value"];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.hotPink.withOpacity(0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isSelected ? AppColors.hotPink : AppColors.line,
                    width: isSelected ? 2.5 : 1.5,
                  ),
                  boxShadow: isSelected ? AppShadow.soft : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  child: RadioListTile<String>(
                    value: account["value"],
                    groupValue: answers["selectedAccount"],
                    activeColor: AppColors.hotPink,
                    title: Text(
                      account["label"],
                      style: GoogleFonts.fredoka(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: AppColors.ink,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          account["tagline"],
                          style: GoogleFonts.inter(color: AppColors.inkMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        ...(account["features"] as List).map(
                          (feature) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle_outline_rounded, size: 16, color: AppColors.hotPink),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    feature.toString(),
                                    style: GoogleFonts.fredoka(fontSize: 13, color: AppColors.ink),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onChanged: (value) {
                      setState(() {
                        answers["selectedAccount"] = value;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        GradientButton(
          label: 'Continue 👑',
          icon: Icons.star_rounded,
          onPressed: answers["selectedAccount"] == null ? null : nextStep,
        ),
      ],
    );
  }

  Widget buildReviewStep() {
    return Column(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.line, width: 1.5),
            ),
            child: ListView(
              children: answers.entries.map((entry) {
                if (entry.key == 'termsAccepted') return const SizedBox();
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.w600, color: AppColors.inkMuted, fontSize: 13),
                      ),
                      Text(
                        entry.value.toString(),
                        style: GoogleFonts.fredoka(fontWeight: FontWeight.w700, color: AppColors.hotPink, fontSize: 15),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        GradientButton(
          label: 'Submit & Slay! 💅',
          icon: Icons.rocket_launch_rounded,
          onPressed: () {
            FunAudioPlayer.playPopupFanfare();
            nextStep();
          },
        ),
      ],
    );
  }

  Widget buildSuccessStep(Map<String, dynamic> step) {
    final name = answers['fullName']?.toString() ?? 'Bestie';
    final nameParts = name.trim().split(RegExp(r'\s+'));
    final phone = answers['phoneNumber']?.toString() ?? '09171234567';
    final email = answers['emailAddress']?.toString() ?? 'user@fabulous.com';
    final dob = answers['dateOfBirth']?.toString() ?? '10/24/2000';
    final gender = answers['gender']?.toString() ?? 'Non-Binary';

    DateTime dobDate;
    try {
      final parts = dob.split('/');
      dobDate = DateTime(int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]));
    } catch (_) {
      dobDate = DateTime(2000, 1, 1);
    }

    final newUser = UserModel(
      firstName: nameParts.first,
      lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
      email: email,
      phone: phone,
      dateOfBirth: dobDate,
      gender: gender,
      taxBracket: taxBrackets.first,
      savings: 10000,
    );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: electricRainbowGradient,
              shape: BoxShape.circle,
              boxShadow: AppShadow.neonGlow,
            ),
            child: const Center(
              child: Text('🥳', style: TextStyle(fontSize: 54)),
            ),
          ),
          const SizedBox(height: 24),

          Text(
            step['title'] ?? 'Welcome to GBBT!',
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 10),

          Text(
            'Your account has been created, ${newUser.firstName}! ₱10,000 Starter Bonus added to your vault! 💸🌈',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppColors.inkMuted,
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 36),

          GradientButton(
            label: 'Enter GBBT Vault ✨',
            icon: Icons.key_rounded,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => DashboardScreen(user: newUser)),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildCurrentStep(Map<String, dynamic> step) {
    switch (step["screenType"]) {
      case "form":
        return buildFormStep(step);
      case "terms":
        return buildTermsStep(step);
      case "account-selection":
        return buildAccountSelectionStep(step);
      case "review":
        return buildReviewStep();
      case "success":
        return buildSuccessStep(step);
      default:
        return const Center(child: Text("Unsupported step type"));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (journey == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.hotPink),
        ),
      );
    }

    final step = steps[currentStepIndex];

    return Scaffold(
      body: BonggaBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              children: [
                // Top Header Row
                Row(
                  children: [
                    if (currentStepIndex > 0 && step['screenType'] != 'success')
                      IconButton(
                        onPressed: previousStep,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.ink),
                        style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                      )
                    else
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded, size: 20, color: AppColors.ink),
                        style: IconButton.styleFrom(backgroundColor: Colors.white, elevation: 2),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RainbowShimmerText(text: journey!['journeyName'], fontSize: 20),
                    ),
                    InteractiveSticker(
                      text: '✨ STEP ${currentStepIndex + 1}/${steps.length}',
                      backgroundColor: AppColors.neonGold,
                      textColor: AppColors.ink,
                      rotateAngle: 0.04,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Electric Rainbow Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: LinearProgressIndicator(
                    value: (currentStepIndex + 1) / steps.length,
                    minHeight: 10,
                    backgroundColor: AppColors.line,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.hotPink),
                  ),
                ),
                const SizedBox(height: 20),

                // Step Content Card
                Expanded(
                  child: BonggaCard(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        if (step['screenType'] != 'success') ...[
                          const RainbowMark(size: 64),
                          const SizedBox(height: 12),
                          Text(
                            step['title'],
                            textAlign: TextAlign.center,
                            style: GoogleFonts.fredoka(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          if (step['subtitle'] != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              step['subtitle'],
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: AppColors.inkMuted,
                                fontSize: 13.5,
                              ),
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
                        Expanded(
                          child: buildCurrentStep(step),
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